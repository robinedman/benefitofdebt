# encoding: utf-8

# Mass assignment Lingonberry Style
# ==================================
# While there is support for mass assignment in ActiveModel and thus
# in Mongoid, it seems to lack the ability to specify publicly accessible
# fields and fields that are only supposed to be publicly readable.

# Ideally we'd like to have some fields that a client should be able to
# update and some they should be able to read but not update.

# So this is a very basic export/import (or mass assignment) implemenation
# meant to be mixed into a Mongoid model.

# Also includes basic REST security implementation.

# Usage:
# Export with as_external_document.
# Update attributes with hash from client with external_update.

module LingonberryMongoidImportExport
  
  def self.included(base)
    base.const_set(:EXTERNALLY_READABLE_FIELDS, ['_id'])
    base.const_set(:EXTERNALLY_ACCESSIBLE_FIELDS, [])
    base.const_set(:REST_INTERFACE, [])

    base.send(:include, InstanceMethods)
    base.extend(ClassMethods)
  end

  module InstanceMethods
    def as_external_document
     allowed_fields = (self.class.const_get(:EXTERNALLY_ACCESSIBLE_FIELDS) + self.class.const_get(:EXTERNALLY_READABLE_FIELDS)).map(&:to_s)
     doc = self.as_document
     
     # note: id fix for client side libraries like Spine.js,
     # who rely on an id attribute being present.
     doc['id'] = doc['_id']

     doc.slice(*allowed_fields + ['id'])
    end

    def external_update!(document_as_hash)
      allowed_updates = document_as_hash.slice(*self.class.const_get(:EXTERNALLY_ACCESSIBLE_FIELDS).map(&:to_s))
      update_attributes!(allowed_updates)
    end

    # Does the model allow a certain REST operation?
    # If no operation given: Does the model allow any REST operation at all?
    def rest?(operation)
      if operation
        self.class.const_get(:REST_INTERFACE).include?(operation)
      else
        ! self.class.const_get(:REST_INTERFACE).empty?
      end
    end
  end

  module ClassMethods
    # Externally accessible fields and embedded documents.
    def externally_accessible(*fields)
      const_get(:EXTERNALLY_ACCESSIBLE_FIELDS).push(*fields)
    end

    # Externally readable fields and embedded documents.
    def externally_readable(*fields)
      const_get(:EXTERNALLY_READABLE_FIELDS).push(*fields)
    end

    # Used to define allowed REST operations (e.g. :read, :create, :update, :delete).
    # Example usage:
    # class MyModel 
    #   include Mongoid::Document
    #   include LingonberryMongoidImportExport
    #
    #   rest_interface :read, :update, :delete
    #
    def rest_interface(*operations)
      const_get(:REST_INTERFACE).push(*operations)
    end

    # Does the model allow a certain REST operation?
    # If no operation given: Does the model allow any REST operation at all?
    def rest?(operation = nil)
      if operation
        const_get(:REST_INTERFACE).include?(operation)
      else
        ! const_get(:REST_INTERFACE).empty?
      end
    end
  end
end