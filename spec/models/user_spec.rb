require 'rails_helper'

RSpec.describe User, type: :model do
  it 'user 有email' do   #]
    user = User.new email: 'wang@qq.com'
    expect( user.email ).to eq 'wang@qq.com'  # test code
  end
end
