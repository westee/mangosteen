class Api::V1::TagsController < ApplicationController
  def index
    current_user_id = request.env["current_user_id"]
    return head :unauthorized if current_user_id.nil?

    tags = Tag.where({ user_id: current_user_id }).page params[:page]
    render json: {
             resources: tags,
             pager: {
               count: Tag.count,
               page: params[:page] || 1,
               per_page: Tag.default_per_page,
             },
           }
  end

  def create
    item = Item.new amount: params[:amount], notes: params[:note]
    if item.save
      render json: { resources: item }
    else
      render json: { resources: item.errors }
    end
  end
end
