class ListsController < ApplicationController

    get '/lists' do
        if logged_in?
            @users = User.all    
            erb :'lists/lists'
        else
            redirect '/login'
        end
    end

    get '/lists/new' do
        if logged_in?
            erb :'lists/new'
        else
            redirect '/login'
        end
    end

    post '/lists' do
        if !params[:list][:name].empty?
            @list = create_new_list(params)
            flash[:message] = "List Successfully Created!"
            redirect "/lists/#{@list.id}"
        else
            flash[:error] = "Please enter a name for your list."
        end
    end

    get '/mylists' do
        if logged_in?
            @user = current_user
            if !@user.lists.empty?
                @lists = gather_list_hashes(@user.lists) 
                erb :'lists/mylists'
            else
                redirect "profile/#{@user.id}"
            end
        else 
            redirect '/login'
        end  
    end

    get '/lists/:id' do
        if logged_in?
            @list = List.find(params[:id])
            erb :'lists/show'
        else
            redirect '/login'
        end
    end

    get '/lists/:id/edit' do
        if logged_in?

            @list = List.find(params[:id])
            @user = current_user
            erb :'lists/edit'
        else
            redirect '/login'
        end
    end

    patch '/lists/:id' do
        List.update(params[:id], {name: params[:list][:name]})
        params[:items].each do |item|
            if !item[:id]
                if item[:name]
                    Item.create(name: item[:name], price: item[:price], ranking: item[:ranking], list_id: params[:id])
                end
            else
                Item.update(item[:id], {name: item[:name], price: item[:price], ranking: item[:ranking]})
            end
        end
        redirect "/lists/#{params[:id]}"
    end

    delete '/lists/:id' do
        @list = List.find(params[:id])
        @list.items.each {|item| Item.update(item.id, {list_id: nil})}
        List.delete(params[:id])
        redirect "/mylists"
    end

end
