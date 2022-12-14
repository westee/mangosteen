class UserMailer < ApplicationMailer
  # default from: 'notifications@example.com'

  def welcome_email(email)
    p '------------------邮件--------------'
    p email
    validationCode = ValidationCode.order(created_at: :desc).find_by_email(email)
    @code = validationCode.code
    mail(to: email, subject: "山竹记账验证码")
  end
end
