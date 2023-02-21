require 'sinatra'
require 'sinatra/cookies'
require "sinatra/cors"
require "sinatra/namespace"
require 'jwt'

require_relative './helpers/application_helpers.rb'
require_relative './jwt/Jwt.rb'

set :server, %w[puma]
set :sessions, false

class Auth < Sinatra::Base

  before do
    response.headers['Access-Control-Allow-Credentials'] = "true"
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
  set :cookie_options do
    {
      :secure => true,
      :same_site => :none
    }
  end
  # set :jwt, ''

  def getjwt(user_id)
    begin
      jwt = UserJWT.new(user_id)
      jwt.duration = 30 # soit 2 minutes
      token = jwt.issue
      token
    rescue => exception
      exception
    end
  end

  def login(client)
    if client["name"] == "thiebald" && client ["password"] == "123"
      return true
    else
      return false
    end 
  end
  
  namespace '/auth' do

    post '/login' do
      #headers '__auth__' => 'jesuisunjwt'
      client = JSON.parse request.body.read
      loggedIn = login client
      if loggedIn == true
        refresh = UserJwtRefresh.new(15).issue
        jwt = getjwt(115)
        cookies[:refresh] = refresh
        headers '__auth__' => jwt
        json_status 200, "success"
      else
        json_status 409, "Erreur d'identification"
      end
    end

    get '/getjwt' do
      refresh = request.env['HTTP_COOKIE']
      settings.jwt = getjwt(refresh)  
      json_status 200, "bonjour"
      #else
       # json_status 409, "erreur"
      #end
    end

  end

  namespace '/data' do

    before do
      
      unless request.env['REQUEST_METHOD'] == 'OPTIONS'
        
        # puts request.env['HTTP___AUTH__']

        if request.env['HTTP___AUTH__'] == '' || !request.env['HTTP___AUTH__']
          halt 401, { 'Content-Type' => 'text/plain' }, 'La ressource n\'est pas accessible.'
        else
          if UserJWT.verify(request.env['HTTP___AUTH__']) == false
            redirect "http://localhost:5173"
          end
        end

      end


    end

    get '/cars' do

      cars = [
        { id: 0, marque: "Peugeot", modele: "205" },
        { id: 1, marque: "Renault", modele: "berline" },
        { id: 2, marque: "Talbot", modele: "T26 Record" },
      ]

#     puts request.env['HTTP___AUTH__']
      json_status 200, cars
    end

    get '/car/:id' do
      
      cars = [
        { id: 0, marque: "Peugeot", modele: "205", prix: "2 500 €" },
        { id: 1, marque: "Renault", modele: "berline", prix: "45 000 €"  },
        { id: 2, marque: "Talbot", modele: "T26 Record", prix: "35 000 €"  },
      ]

      car = cars.find{ |cc| cc[:id] == 0 }

      json_status 200, car

    end

    
  end



end