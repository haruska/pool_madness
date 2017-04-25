class UserMailer < ActionMailer::Base
  default from: "\"#{ENV['ADMIN_NAME']}\" <#{ENV['ADMIN_EMAIL']}>"

  def welcome_message(user)
    @user = user
    mail(to: "\"#{user.name}\" <#{user.email}>", subject: "Thanks for Registering")
  end
end
