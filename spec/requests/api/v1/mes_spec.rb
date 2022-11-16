require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe "me", type: :request do
  include ActiveSupport::Testing::TimeHelpers
  describe "获取当前用户" do
    it "登录后成功获取" do
      user = User.create email: 'xxx@qq.com'
      post '/api/v1/session', params: {email: 'xxx@qq.com', code: '123456'}
      json = JSON.parse response.body
      jwt = json['jwt']
    
      get '/api/v1/me', headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      
      # expect(json['jwt']).to be_a(String)
    end

    it "jwt过期" do
      travel_to Time.now - 3.hours
      user1 = User.create email: 'xxx@qq.com'
      jwt = user1.generate_token
      travel_back
      get '/api/v1/me', headers: {'Authorization': "Bearer #{jwt}"}
      expect(response).to have_http_status(401)
    end

    it "jwt没过期" do
      travel_to Time.now - 1.hours
      user1 = User.create email: 'xxx@qq.com'
      jwt = user1.generate_token
      travel_back
      get '/api/v1/me', headers: {'Authorization': "Bearer #{jwt}"}
      expect(response).to have_http_status(200)
    end
  end
end
