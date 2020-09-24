class ListsController < ApplicationController

    get '/lists' do
        if logged_in?
            @lists = List.all
            erb :'lists/lists'
        else
            redirect '/login'
        end
    end

    get '/lists/new' do
        erb :'lists/new'
    end

    post '/lists' do
        @list = List.create(name: params[:list][:name], user_id: session[:user_id])
        @items = params[:items].map do |item|
           Item.create(name: item[:name], price: item[:price], ranking: item[:ranking], list_id: @list.id)
        end  

        erb :'lists/show'
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

    get '/lists/:id/edit' do
        @list = List.find(4)
        @user = current_user
        erb :'lists/edit'
    end
    



end
