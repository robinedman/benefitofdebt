class Session
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sid, type: String
  belongs_to :user

  externally_readable :sid

  rest_interface :read,
                 :update,
                 :delete
  
  def self.authenticate(sid)
    session = self.find_by(sid: sid)
    if session
      session.user
    else
      false
    end
  end
end