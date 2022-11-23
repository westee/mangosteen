class Api::V1::TagsController < ApplicationController
  def index
    current_user_id = request.env["current_user_id"]
    return head :unauthorized if current_user_id.nil?

    tags = Tag.where({ user_id: current_user_id }).page params[:page]
    render json: {
             resources: tags,
             pager: {
               count: tags.count,
               page: params[:page] || 1,
               per_page: Tag.default_per_page,
             },
           }
  end

  def show
    current_user_id = request.env["current_user_id"]
    tag = Tag.find_by({ id: params[:id] })
    if tag.user_id == current_user_id
      render json: { resource: tag }
    else
      head 403
    end
  end

  def create
    current_user_id = request.env["current_user_id"]
    return render status: 401 if current_user_id.nil?
    # tag = Tag.new name: params[:name], sign: params[:sign], user_id: current_user_id
    # if tag.save # && (params[:name] && params[:sign])
    if (params[:name] && params[:sign]) # Tag.create name: params[:name], sign: params[:sign], user_id: current_user_id
      tag = Tag.create name: params[:name], sign: params[:sign], user_id: current_user_id
      render json: { resource: tag }, status: :ok
    else
      render json: { errors: {name: ["can't be blank"], sign: ["can't be blank"]} },status: :unprocessable_entity
      # render json: { errors: tag.errors },status: :unprocessable_entity
    end
  end

  def update
    current_user_id = request.env["current_user_id"]
    tag = Tag.find_by({ id: params[:id] })
    tag.update params.permit(:name, :sign)
    if tag.errors.empty?
      render json: {resource: tag}
    else
      render json: {errors: tag.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    tag = Tag.find params[:id]
    return head :forbidden unless tag.user_id == request.env['current_user_id']
    tag.deleted_at = Time.now
    if tag.save
      head 200
    else
      render json: {errors: tag.errors}, status: :unprocessable_entity
    end
  end
end
