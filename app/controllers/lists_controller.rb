class ListsController < ApplicationController

    get '/lists' do
        if logged_in?
            all_lists = List.all
            @valid_lists = all_lists.select {|list| !list.items.empty?}
            @lists = @valid_lists.map do |list|
                hash = {}
                nill = list.items.select {|item| item[:ranking] == nil}
                ranked = list.items.select {|item| item[:ranking] != nil}
                sorted = ranked.sort_by {|item| -item[:ranking]}
                sorted.push(*nill) unless nill.empty?
                sorted
                hash = {list: list, user: User.find(list.user_id).name, items: sorted}
                hash
            end
    
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
            if !item[:name].empty?
           Item.create(name: item[:name], price: item[:price], ranking: item[:ranking], list_id: @list.id)
            end
        end  

        redirect "/lists/#{@list.id}"
    end

    get '/mylists' do
        if logged_in?
            @user = current_user
            @lists = @user.lists 
            erb :'lists/mylists'
        else 
            redirect '/login'
        end  
    end

    get '/lists/:id' do
        if logged_in?
            @list = List.find(params[:id])
            @items = @list.items
            erb :'lists/show'
        else
            redirect '/login'
        end
    end

    get '/lists/:id/edit' do
        @list = List.find(params[:id])
        @user = current_user
        erb :'lists/edit'
    end

    patch '/lists/:id' do
        List.update(params[:id], {name: params[:list][:name]})
        params[:items].each do |item|
            Item.update(item[:id], {name: item[:name], price: item[:price], ranking: item[:ranking]})
        end
        redirect "/lists/#{params[:id]}"
    end

    delete '/lists/:id' do
        @list = List.find(params[:id])
        @list.items.each {|item| Item.update(item.id, {list_id: nil})}
        List.delete(params[:id])
        redirect '/welcome'
    end

end
