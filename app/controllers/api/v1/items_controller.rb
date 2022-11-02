class Api::V1::ItemsController < ApplicationController
    def index
        items = Item.page params[:page]
        count = Item.count
        render json: {
            resource: items,
            count: count
        }
    end

    def create 
        item = Item.new amount:1, notes: 'test'
        if item.save
            render json: {resource: item}
        else
            render json: {resource: 'err'}
        end
    end
end
