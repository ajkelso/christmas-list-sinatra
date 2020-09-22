class UsersController < ApplicationController

    get '/login' do
        erb :'users/login'
    end

    post '/login' do
       user = User.find_by(username: params[:user][:username])
       if user && user.authenticate(params[:user][:password]) 
        session[:user_id] = user.id 
        redirect '/welcome'
       else
        redirect '/login'
       end
    end

    get '/signup' do
        erb :'users/signup'
    end

    post '/signup' do
        @user = User.new(params[:user])
        create_user(params[:user])
        redirect '/welcome'
    end

    get '/welcome' do
        @user = current_user
        erb :'users/welcome'
    end

    get '/logout' do
        if session[:user_id] != nil
            session.destroy
            redirect '/login'
        else
            redirect to '/'
        end
    end
end
