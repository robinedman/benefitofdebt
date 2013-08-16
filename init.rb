#encoding: utf-8

require_relative 'helpers'
require 'cuba'
require 'rack/protection'
require 'mongoid'
require_relative 'lib/lingonberrymongoidimportexport'
require 'rack/logger'
require 'securerandom'
require 'rack/post-body-to-params'
require_from_directory 'models'

# ===================
# Configures Mongoid
# ===================

Mongoid.load!('mongoid.yml')
