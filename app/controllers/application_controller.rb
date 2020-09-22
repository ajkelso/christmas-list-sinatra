require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "SantasGotABrandNewBag"
  end

  get "/" do
    erb :'users/index'
  end

  helpers do
    def logged_in?
        !!session[:user_id]
    end

    def current_user
        User.find(session[:user_id])
    end

    def login(user_id)
        session[:user_id] = user_id
    end

    def create_user(params)
        @user = User.new(params)
        if @user.save 
            login(@user.id)
        else  
            redirect '/signup'
        end
    end

end

end
