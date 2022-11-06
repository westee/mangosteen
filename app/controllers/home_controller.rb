class HomeController < ApplicationController
  def index
    render json: {
      message: "大家好 才是真的好"
    }
  end
end
