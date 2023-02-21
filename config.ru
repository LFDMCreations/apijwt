require './app/api.rb'
require 'rack/protection'
#disable :protection # not certain this is necessary
#use Rack::Protection, :except => :session_hijacking

run TestJwt
