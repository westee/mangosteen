require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /items" do
    it "works! (now write some real specs)" do
      11.times {
        Item.create amount: 99
      }
      expect(Item.count).to eq 11
      get '/api/v1/items'
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(10)
     
      get '/api/v1/items?page=2'
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)

    end
  end

  describe "POST /items" do
    it "works! (now write some real specs)" do
      expect {
        post '/api/v1/items', params: {amount: 97}
      }.to change {Item.count}.by 1
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources']['id']).to be_kind_of(Numeric)
      expect(json['resources']['amount']).to eq(97)
      
    end
  end
end
