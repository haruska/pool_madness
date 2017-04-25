class UserMailer < ApplicationMailer
  def welcome_message(user)
    @user = user
    mail(to: "\"#{user.name}\" <#{user.email}>", subject: "Thanks for Registering")
  end
end
