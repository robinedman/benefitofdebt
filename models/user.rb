#encoding: utf-8

require 'digest'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include LingonberryMongoidImportExport

  has_many :expense

  externally_accessible '_id'

  externally_readable   :active,
                        :sms_account,
                        :premium_until
  
  rest_interface :read, 
                 :update, 
                 :delete

  field :email, type: String
  field :first_name, type: String, default: ""
  field :last_name, type: String, default: ""
  field :mobile_number, type: String
  field :hashed_password, type: String
  field :active, type: Boolean, default: true # it's free
  
  # Diagnostic fields
  
  has_one :session
  @@salt = '09E30369-A91F-4D2B-B4B8-CE4394D976BA'
  
  validates :email, presence: true, uniqueness: true, length: { maximum: 64 }
  # Note that hashed_password isn't hashed at the point of validation
  validates :hashed_password, presence: true, length: { minimum: 6, maximum: 64}
  
  before_validation do |document|
    # When a user registers, downcase the email address.
    # This will downcase the email unnecessarily whenever the document
    # is updated. But life is life, what to do? 
    document.email.downcase! if document.email
  end

  # This is where hashed_password becomes true to it's name
  before_create do |document|
    document.hashed_password = encrypt(document.hashed_password)
  end
  
  def has_password?(submitted_password)
    self.hashed_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = self.find_by(email: email.downcase)
    return nil unless user
    return user if user.has_password?(submitted_password)
  end
  
  # Needs both a new_password (duh) and old_password for extra security
  def change_password(new_password, old_password)
    raise WrongPassword unless has_password?(old_password)
    change_password!(new_password)
  end
  
  # Only needs new_password. Use with care since possibly someone without proper
  # authority could arbitrarily change the password.
  def change_password!(new_password)
    # We really want to validate the new_passord before it gets hashed.
    # We jut don't know how. Crap.
    if new_password.length >= 6 && new_password.length <= 64 
      self.update_attribute(:hashed_password, encrypt(new_password))
    else
      raise NewPasswordFailedValidation
    end
  end
  
  class WrongPassword < StandardError
    def message
      "Submitted password does not match."
    end
  end

  class NewPasswordFailedValidation < StandardError
    def message
      "New password failed validation."
    end
  end
  

  private   
    def encrypt(s)
      hash_string(@@salt + s)
    end
    
    def hash_string(s)
      Digest::SHA2.hexdigest(s)
    end
end
