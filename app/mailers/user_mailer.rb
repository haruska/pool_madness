class UserMailer < ActionMailer::Base
  default from: "\"Haruska Pool Madness\" <#{ENV['ADMIN_EMAIL']}>"

  def welcome_message(user)
    @user = user
    mail(:to => "\"#{user.name}\" <#{user.email}>", :subject => "Thanks for Registering")
  end

  def last_chance(user)
    @user = user
    mail(:to => "\"#{user.name}\" <#{user.email}>", :subject => "Last Chance to fill out a March Madness Bracket")
  end

  def all_set(user)
    @user = user
    mail(:to => "\"#{user.name}\" <#{user.email}>", :subject => "Thanks for your bracket entry")
  end

  def come_back(user)
    @user = user
    mail(:to => "\"#{user.name}\" <#{user.email}>", :subject => "Fill out your March Madness Bracket!")
  end
end
