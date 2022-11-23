class User < ApplicationRecord
    validates :email, presence: true

    def generate_token
        payload = { user_id: self.id, exp: (Time.now + 7.days).to_i }
        return JWT.encode payload, Rails.application.credentials.hmac_secret, 'HS256'
    end

    def generate_auth_header
        return {'Authorization': "Bearer #{self.generate_token}"}
    end
end
