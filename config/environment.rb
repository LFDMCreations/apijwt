require 'sequel'
APP_ENV = ENV["RACK_ENV"] || "development"
ENV['SINATRA_ENV'] ||= "development"

require 'require_all'
require 'bundler/setup'
Bundler.require(ENV['SINATRA_ENV'])

if APP_ENV == "development"
  DB = Sequel.connect('postgres://thiebo@localhost/cars')
else
  DB = Sequel.connect(ENV['SCALINGO_POSTGRESQL_URL']) ## at Scalingo
end
  
 DB.extension(:connection_validator)
 DB.pool.connection_validation_timeout = -1
