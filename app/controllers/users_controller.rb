class UsersController < ApplicationController

    get '/login' do
        if !logged_in?
            erb :'users/login'
        else
            redirect '/welcome'
        end
    end

    post '/login' do
        user = User.find_by(username: params[:user][:username])
       if user && user.authenticate(params[:user][:password]) 
        session[:user_id] = user.id 
        redirect '/welcome'
       else
        binding.pry
        redirect '/login'
       end
    end

    get '/signup' do
        if !logged_in?
            erb :'users/signup'
        else
            redirect '/welcome'
        end
    end

    post '/signup' do
        @user = User.new(params[:user])
        create_user(params[:user])
        redirect '/welcome'
    end

    get '/welcome' do
        if logged_in?
            @user = current_user
            erb :'users/welcome'
        else
            redirect '/login'
        end

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
