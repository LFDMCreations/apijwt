require 'sinatra'
require "sinatra/cors"
require "sinatra/namespace"
require 'jwt'

require_relative './helpers/application_helpers.rb'
require_relative './jwt/Jwt.rb'
#require_relative './populate.rb'
set :server, %w[puma]
set :sessions, false

class TestJwt < Sinatra::Application

  before do
    response.headers['Access-Control-Allow-Credentials'] = "true"
#    response.headers['Access-Control-Expose-Headers'] = ["__refresh__", "__auth__"]
    response.headers['Access-Control-Expose-Headers'] = "__auth__"
  end
    
  register Sinatra::Cors
  ########################################
  #### ALLOW ORIGIN ALSO IN CONFIG.RU ####
  ########################################
  set :allow_origin, "http://127.0.0.1:5173 http://localhost:5173 https://client-six-sand.vercel.app" # <== ALSO IN CONFIG.RU ::::::::
  #set :allow_origin, "http://localhost:3000" # <== ALSO IN CONFIG.RU ::::::::
  set :allow_headers, "Access-Control-Allow-Origin,content-type,__auth__,Access-Control-Allow-Credentials"
  set :allow_methods, "GET, HEAD, POST, DELETE"

  def getjwt(user_id)
    begin
      jwt = UserJWT.new(user_id)
      jwt.duration = 3# soit 2secondes
      token = jwt.issue
      token
    rescue => exception
      exception
    end
  end

  def login(client)
    begin
      user_id = User.find(name: client["name"])[:id]
      passe = UserPassword.find(user_id: user_id)[:passe]
      if passe
        return user_id
      else
        return false
      end
    rescue => e
      return e.message
    end
  end
  
  namespace '/auth' do

    post '/login' do
      client = JSON.parse request.body.read
      user_id = login client
      if user_id.class == Integer
        jwt = getjwt(user_id)
        refresh = UserJwtRefresh.new(user_id)
        headers '__auth__' => jwt
        json_status 200, refresh.issue
      else
        json_status 409, "Erreur d'identification"
      end
    end

    post '/getjwt' do
      renouv = JSON.parse request.body.read
      puts renouv
      begin
        user_id = UserJwtRefresh.verify(renouv)
        jwt = getjwt(user_id)
        headers '__auth__' => jwt
        json_status 200, "success"
      rescue => e
        json_status 409, e.message
      end
    end
  end

  namespace '/data' do

    before do
      
      unless request.env['REQUEST_METHOD'] == 'OPTIONS'

        begin
          if request.env["HTTP___AUTH__"] == '' || !request.env["HTTP___AUTH__"]
            halt 401, { 'Content-Type' => 'text/plain' }, 'La ressource n\'est pas accessible.'
          end
          verification = UserJWT.verify(request.env["HTTP___AUTH__"])
          unless verification.class == Integer
            halt 409, { 'Content-Type' => 'application/json' }, {reason: verification}.to_json
          end
        rescue => e
          halt 409, e.message  
        end
      end
    end

    get '/cars' do
      cars = DB[:cars].all
      json_status 200, cars
    end

    get '/car/:id' do
      puts params[:id]
      car = Car[params[:id]].values
      json_status 200, car
    end

  end

end
