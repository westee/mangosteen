class ValidationCode < ApplicationRecord
  validates :email, presence: true

	def generate_code
    self.code = SecureRandom.random_number.to_s[2..7]
  end

	def send_email
    UserMailer.welcome_email(self.email)
  end
end
