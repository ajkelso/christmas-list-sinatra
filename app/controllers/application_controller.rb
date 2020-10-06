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

        def create_new_list(params)
            @list = List.new(name: params[:list][:name], user_id: session[:user_id])
        end

        def create_new_items(params)
            items = params[:items].map do |item| 
                Item.new(name: item[:name], price: item[:price], ranking: item[:ranking], list_id: @list.id)
            end
            items.each do |item|
                item.save
            end 
        end

        def days_to_xmas
            (Date.new(2020, 12, 25)-Date.today).to_i
        end

        def not_list_owner
            session[:user_id] != @list.user_id
        end
    end
end
