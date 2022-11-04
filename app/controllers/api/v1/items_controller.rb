class Api::V1::ItemsController < ApplicationController
    def index
        items = Item.page params[:page]
        count = Item.count
        render json: {
            resources: items,
            count: count
        }
    end

    def create 
        item = Item.new amount: params[:amount], notes: params[:note]
        if item.save
            render json: {resources: item}
        else
            render json: {resources: item.errors}
        end
    end
end
