class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@iflix.com", subject: "Welcome to iflix!"
  end

end