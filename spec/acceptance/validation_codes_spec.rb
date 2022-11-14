require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "验证码" do

  post "/api/v1/validation_codes" do
    # header "Content-Type", "application/json"
    parameter :email, "邮件接收方email", type: :string, with_example: true
    let(:email) { "email@example.com" }
    example "发送验证码" do
      do_request
      expect(status).to eq 200
      res = JSON.parse(response_body)
      expect(res[:code]).to eq nil

    end
  end
end