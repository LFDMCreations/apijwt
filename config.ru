require_relative './config/environment'
require './app/api.rb'
require 'rack/protection'
#disable :protection # not certain this is necessary
#use Rack::Protection, :except => :session_hijacking

Dir.glob('./app/models/*.rb').each { |file| require file }

run TestJwt
