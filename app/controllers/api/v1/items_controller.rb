class Api::V1::ItemsController < ApplicationController
  def index
    current_user_id = request.env["current_user_id"]
    return head :unauthorized if current_user_id.nil?

    items = Item.where({ user_id: current_user_id })
      .where({ created_at: params[:create_after]..params[:create_before]})
      .page params[:page]
    render json: {
             resources: items,
             pager: {
               count: Item.count,
               page: params[:page] || 1,
               per_page: Item.default_per_page,
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
