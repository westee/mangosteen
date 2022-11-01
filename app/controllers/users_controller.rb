class UsersController < ApplicationController
  def create
    user = User.new email:'wang@q.com', name:'wang'
    if user.save
      render json: user
    else
      p '失败 create'
    end
    
  end

  def show
    user = User.find_by_id params[:id]
    if user
      render json: user
    else
      head 404
    end
  end
end
