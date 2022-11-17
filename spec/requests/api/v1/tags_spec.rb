require 'rails_helper'

RSpec.describe "Tags", type: :request do
  describe "获取标签" do
    it "未登录获取标签" do
      get '/api/v1/tags' 
      expect(response).to have_http_status(:unauthorized)
    end

    it "登录获取标签" do
      user1 = User.create email: '1@qq.com'
      user2 = User.create email: '2@qq.com'

      11.times do |i|  Tag.create name: "tag #{i}", sign: "sign name", user_id: user1.id end
      11.times do |i|  Tag.create name: "tag #{i}", sign: "sign name", user_id: user2.id end

      get '/api/v1/tags' , headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(10)
      get '/api/v1/tags?page=2', headers: user1.generate_auth_header
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)

    end
  end
end
