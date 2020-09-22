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
        
    end


end
