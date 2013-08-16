#encoding: utf-8

require 'cuba'
require 'rack/protection'
require 'mongoid'
require_relative 'lib/lingonberrymongoidimportexport'
require 'rack/logger'
require 'securerandom'
require 'rack/post-body-to-params'

PUBLIC_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'public/'))

puts PUBLIC_PATH

Cuba.use Rack::Static, :urls => ['/public',
                                 '/javascripts/app/controllers.js',
                                 '/favicon.ico']
