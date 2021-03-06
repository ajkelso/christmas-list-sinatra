class ListsController < ApplicationController

    get '/lists' do
        if logged_in?
            @users = User.all    
            erb :'lists/lists'
        else
            redirect '/'
        end
    end

    get '/lists/new' do
        if logged_in?
            erb :'lists/new'
        else
            redirect '/'
        end
    end

    post '/lists' do
        @list = create_new_list(params)
        if @list.save
            create_new_items(params)
            flash[:message] = "List Successfully Created!"
            redirect "/lists/#{@list.id}"
        else 
            redirect "/lists/new"
        end
    end

    get '/mylists' do
        if logged_in?
            @user = current_user
            if !@user.lists.empty?
                erb :'lists/mylists'
            else
                flash[:error] = "You don't have any lists and there are only #{days_to_xmas} days left until Christmas!!"
                redirect "profile/#{@user.id}"
            end
        else 
            redirect '/'
        end  
    end

    get '/lists/:id' do
        if logged_in?
            @list = List.find(params[:id])
            erb :'lists/show'
        else
            redirect '/'
        end
    end

    get '/lists/:id/edit' do
        if logged_in?
            @list = List.find(params[:id])
            if not_list_owner
                redirect "/profile/#{current_user.id}"
            end
            @user = current_user
            erb :'lists/edit'
        else
            redirect '/'
        end
    end

    patch '/lists/:id' do
        @list = List.find(params[:id])
        if not_list_owner
            redirect "/profile/#{current_user.id}"
        end
        List.update(params[:id], {name: params[:list][:name]})
        params[:items].each do |item|
            if !item[:id]
                Item.create(name: item[:name], price: item[:price], ranking: item[:ranking], list_id: params[:id])  
            else
                Item.update(item[:id], {name: item[:name], price: item[:price], ranking: item[:ranking]})
            end
        end
        redirect "/lists/#{params[:id]}"
    end

    delete '/lists/:id' do
        @list = List.find(params[:id])
        if not_list_owner
            redirect "/profile/#{current_user.id}"
        end
        @list.items.each {|item| Item.update(item.id, {list_id: nil})}
        List.delete(params[:id])
        redirect "/mylists"
    end

end
