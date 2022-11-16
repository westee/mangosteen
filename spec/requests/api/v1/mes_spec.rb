require 'rails_helper'

RSpec.describe "me", type: :request do
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
  end
end
