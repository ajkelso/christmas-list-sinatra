require './config/environment'


class ApplicationController < Sinatra::Base
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        register Sinatra::Flash
        set :session_secret, "SantasGotABrandNewBag"
        
    end

    get "/" do
        if logged_in?
            redirect "/profile/#{current_user.id}"
        else 
            erb :'users/index'
        end
    end

    helpers do
        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find(session[:user_id])
        end

        def login(user_id)
            session[:user_id] = user_id
        end

        def create_user(params)
            @user = User.new(params)
            if @user.save 
                login(@user.id)
                redirect "/profile/#{current_user.id}"
            else 
                erb :'users/signup'
            end
        end

        def get_valid_lists(lists)
            lists.select {|list| !list.items.empty?}
        end

        def sort_by_item_ranking(list)
            unranked = list.items.select {|item| item[:ranking] == nil}
            ranked = list.items.select {|item| item[:ranking] != nil}
            sorted = ranked.sort_by {|item| -item[:ranking]}
            sorted.push(*unranked) unless unranked.empty?
            sorted
        end

        def create_list_hash(list)
            hash = {list: list, user: User.find(list.user_id).name, items: sort_by_item_ranking(list)}
        end

        def gather_list_hashes(lists)
            get_valid_lists(lists).map do |list|
                create_list_hash(list)
            end
        end

        def create_new_list(params)
            @list = List.create(name: params[:list][:name], user_id: session[:user_id])
            valid_items = params[:items].select {|item| !item[:name].empty?}
            valid_items.map do |item|
                Item.create(name: item[:name], price: item[:price], ranking: item[:ranking], list_id: @list.id)
            end  
            @list
        end
    end
end
