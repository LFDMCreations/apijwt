#frozen_string_literal: true
source "https://rubygems.org"

ruby '3.2.1'
gem 'sinatra','2.2.0'
gem 'sinatra-contrib', '~> 2.1'

gem 'puma'

gem 'sequel', '~> 5.55'
# necessary for running migrations:
gem 'bigdecimal', '~> 3.1', '>= 3.1.1'
gem "pg"
gem 'require_all'
gem 'bcrypt', '~> 3.1', '>= 3.1.17'
# 4 gems for sending emails:

gem 'sysrandom'
gem 'date'
gem 'rspec', '~> 3.4'
gem 'rake', '~> 11.2', '>= 11.2.2'
gem 'jwt', '~> 2.3'
gem 'sinatra-cors', '~> 1.2'

#gem 'rubocop', '~> 1.39', require: false

group :test, :development do
  gem 'racksh', '~> 1.0'
end
