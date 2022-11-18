require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /items" do
    it "分页-未登录" do
      get '/api/v1/items' 
      expect(response).to have_http_status(:unauthorized)
    end

    it "分页" do
      user1 = User.create email: '1@qq.com'
      user2 = User.create email: '2@qq.com'
      11.times { Item.create amount: 99, user_id: user1.id }
      expect(Item.count).to eq 11

      get '/api/v1/items' , headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(10)
      get '/api/v1/items?page=2', headers: user1.generate_auth_header
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)

    end

    it "按时间筛选" do
      user1 = User.create email: '1@qq.com'
      user2 = User.create email: '2@qq.com'
      Item.create amount: 99, created_at: '2022-11-16', user_id: user1.id
      Item.create amount: 99, created_at: '2022-11-17', user_id: user2.id

      get '/api/v1/items?create_after=2022-11-16&create_before-2022-11-17', headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)

    end

    it "按时间筛选（边界条件）" do
      user1 = User.create email: '1@qq.com'
      Item.create amount: 99, created_at: '2022-11-17', user_id: user1.id
      Item.create amount: 99, created_at: '2022-11-19'

      get '/api/v1/items?create_after=2022-11-16&create_before=2022-11-18', headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)
    end

    it "按时间筛选（边界条件2）" do
      user1 = User.create email: '1@qq.com'
      Item.create amount: 99, created_at: '2022-11-16', user_id: user1.id
      Item.create amount: 99, created_at: '2022-11-17'

      get '/api/v1/items?create_after=2022-11-16', headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)

    end
    it "按时间筛选（边界条件3）" do
      user1 = User.create email: '1@qq.com'
      Item.create amount: 99, created_at: '2022-11-16', user_id: user1.id
      Item.create amount: 99, created_at: '2022-11-16', user_id: user1.id
      Item.create amount: 99, created_at: '2022-11-17', user_id: user1.id

      get '/api/v1/items?create_before=2022-11-16', headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(2)
    end
  end

  describe "创建账目" do
    it "未登录创建" do
      post '/api/v1/items', params: {amount: 97}
      expect(response).to have_http_status(401)
    end
    
    it "登录后创建" do
      user = User.create email: 'xxx@qq.com'
      tag1 = Tag.create name: 'tag1', sign: 'x', user_id: user.id
      tag2 = Tag.create name: 'tag2', sign: 'x', user_id: user.id

      post '/api/v1/items', params: {amount: 97, tags_id: [tag1.id, tag2.id], happened_at: '2018-01-01T00:00:00+08:00' }, headers: user.generate_auth_header
     
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resource']['id']).to be_an(Numeric)
      expect(json['resource']['amount']).to eq(97)
      expect(json['resource']['tags_id']).to eq([tag1.id, tag2.id])
      expect(json['resource']['happened_at']).to eq('2017-12-31T16:00:00.000Z')
    end

    it "创建时 amount、tags_id、happen_at 必填" do
      user = User.create email: 'xxx@qq.com'
      tag1 = Tag.create name: 'tag1', sign: 'x', user_id: user.id
      tag2 = Tag.create name: 'tag2', sign: 'x', user_id: user.id

      post '/api/v1/items', headers: user.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)

      expect(json['errors']['amount'][0]).to eq "can't be blank"
      expect(json['errors']['tags_id'][0]).to eq "can't be blank"
      expect(json['errors']['happened_at'][0]).to eq "can't be blank"
    end
  end
end
