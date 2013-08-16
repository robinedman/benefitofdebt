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

Cuba.use Rack::Static, :urls => ['/public',
                                 '/javascripts/app/controllers.js',
                                 '/favicon.ico']
Cuba.use Rack::Session::Cookie, :expire_after => 60*60*24*60, #sec*min*h*day two months
                                :secret => "Even a potato in a dark cellar has a certain low cunning about him."
Cuba.use Rack::PostBodyToParams

# ===================
# Configures Mongoid
# ===================

Mongoid.load!('mongoid.yml')

# ================
# Sets up logging
# ================

LOG = Logger.new(STDOUT)
LOG.level = Logger::INFO
LOG.datetime_format = "%Y-%m-%d %H:%M:%S"
LOG.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{severity} -- #{msg}\n"
end

def change_log_level(level)
  LOG.level = Kernel.qualified_const_get("Logger::#{level.upcase}")
  puts "Log level set to #{level.upcase}."
end