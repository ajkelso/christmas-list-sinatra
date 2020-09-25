class ListsController < ApplicationController

    get '/lists' do
        if logged_in?
            @lists = gather_list_hashes(List.all)    
            erb :'lists/lists'
        else
            redirect '/login'
        end
    end

    get '/lists/new' do
        erb :'lists/new'
    end

    post '/lists' do
        @list = create_new_list(params)
        redirect "/lists/#{@list.id}"
    end

    get '/mylists' do
        if logged_in?
            @user = current_user
            @lists = gather_list_hashes(@user.lists) 
            erb :'lists/mylists'
        else 
            redirect '/login'
        end  
    end

    get '/lists/:id' do
        if logged_in?
            list = List.find(params[:id])
            @list = create_list_hash(list)
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
