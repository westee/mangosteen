require 'jwt'
class Api::V1::SessionsController < ApplicationController
  def create 
    Session.new params.permit(:email, :code)
    if session.valid?
      User.find_or_create_by email: session.email
      render json: { jwt: user.generate_token }
    else
      render json: { errors: session.errors},status: :unprocessable_entity
    end
  end
end
