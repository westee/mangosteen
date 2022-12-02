class Api::V1::ItemsController < ApplicationController
  def index
    current_user_id = request.env["current_user_id"]
    return head :unauthorized if current_user_id.nil?

    items = Item.where({ user_id: current_user_id })
      .where(happened_at: (datetime_with_zone(params[:happen_after])..datetime_with_zone(params[:happen_before])))

    items = items.where(kind: params[:kind]) unless params[:kind].blank?
    items = items.page(params[:page])

    result = Array.new 
    items.each do |item|
      tag_name = Tag.find_by_id(item.tag_ids[0]).name
      itemWithName = ItemWithName.new amount: item.amount, happened_at: item.happened_at, tag_ids: [123], tag_name: tag_name
      result.push(itemWithName)
    end
   
    render json: {
            resources: result,
             pager: {
               count: items.count,
               page: params[:page] || 1,
               per_page: Item.default_per_page,
             },
           }
  end

  def create
    item = Item.new params.permit(:amount, :happened_at, tag_ids: [])
    item.user_id = request.env["current_user_id"]
    if item.save
      render json: { resource: item }, status: :ok
    else
      render json: { errors: item.errors, uid: request.env["current_user_id"] }, status: 422
    end
  end

  def balance
    current_user_id = request.env["current_user_id"]
    return head :unauthorized if current_user_id.nil?
    items = Item.where({ user_id: current_user_id })
      .where({ happened_at: params[:happened_after]..params[:happened_before] })
    income_items = []
    expenses_items = []
    items.each { |item|
      if item.kind === "income"
        income_items << item
      else
        expenses_items << item
      end
    }
    income = income_items.sum(&:amount)
    expenses = expenses_items.sum(&:amount)
    render json: { income: income, expenses: expenses, balance: income - expenses }
  end

  def summary
    hash = Hash.new
    arr = Array.new
    items = Item
      .where(user_id: request.env["current_user_id"])
      .where(kind: params[:kind])
      .where(happened_at: params[:happened_after]..params[:happened_before])
    items.each do |item|
      if params[:group_by] == "happened_at"
        key = item.happened_at.in_time_zone("Beijing").strftime("%F")
        hash[key] ||= 0
        hash[key] += item.amount
      else
        item.tag_ids.each do |tag_id|
          key = tag_id
          hash[key] ||= 0
          hash[key] += item.amount
        end
      end
    end
    groups = hash
      .map { |key, value| { "#{params[:group_by]}": key, amount: value} }
    if params[:group_by] == "tag_id"
      groups.each do |item|
        tag = Tag.find_by_id(item[:tag_id])
        item[:name] =  tag[:name]
        item[:sign] =  tag[:sign]
      end
    end
    if params[:group_by] == "happened_at"
      groups.sort! { |a, b| a[:happened_at] <=> b[:happened_at] }
    elsif params[:group_by] == "tag_id"
      groups.sort! { |a, b| b[:amount] <=> a[:amount] }
    end
    render json: {
      groups: groups,
      total: items.sum(:amount),
    }
  end
end
