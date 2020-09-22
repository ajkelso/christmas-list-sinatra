class ListsController < ApplicationController

    get '/lists' do
        if logged_in?
            @lists = List.all
            erb :'lists/lists'
        else
            redirect '/login'
        end
    end

    get '/lists/:id' do
        if logged_in?
            @user = current_user
            @lists = @user.lists 
            erb :'lists/mylists'
        else 
            redirect '/login'
        end
        
    end


end
