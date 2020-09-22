class UsersController < ApplicationController

    get '/login' do
        erb :'users/login'
    end

    post '/login' do
        
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
        "You are logged in!"
    end
end
