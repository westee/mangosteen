class UserMailer < ApplicationMailer
    # default from: 'notifications@example.com'

    def welcome_email(code)
       
        @code= code
        mail(to: "wangxudongaita@qq.com", subject: 'Welcome to My Awesome Site')
      end
end
