class UsersController < ApplicationController

    get '/login' do
        if !logged_in?
            erb :'users/login'
        else
            redirect "/profile/#{current_user.id}"
        end
    end

    post '/login' do
        user = User.find_by(username: params[:user][:username])
       if user && user.authenticate(params[:user][:password]) 
        session[:user_id] = user.id 
        redirect "/profile/#{current_user.id}"
       else
        # flash[:error] = "Invalid Username or Password.  Please try again."
        redirect '/login'
       end
    end

    get '/signup' do
        if !logged_in?
            erb :'users/signup'
        else
            redirect "/profile/#{current_user.id}"
        end
    end

    post '/signup' do
        @user = User.new(params[:user])
        create_user(params[:user])
        redirect "/profile/#{current_user.id}"
    end

    get '/profile/:id' do
        if logged_in?
            if current_user.id == params[:id].to_i
                @user = current_user
                erb :'users/profile'
            else
                redirect "profile/#{current_user.id}"
            end
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
