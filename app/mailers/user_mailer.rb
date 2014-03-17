class UserMailer < ActionMailer::Base
  default from: "\"#{ENV['ADMIN_NAME']}\" <#{ENV['ADMIN_EMAIL']}>"

  def welcome_message(user)
    @user = user
    mail(:to => "\"#{user.name}\" <#{user.email}>", :subject => "Thanks for Registering")
  end

  def last_chance(user)
    @user = user
    mail(:to => "\"#{user.name}\" <#{user.email}>", :subject => "Last Chance to fill out a #{ENV['TOURNEY_NAME']} Bracket")
  end

  def all_set(user)
    @user = user
    mail(:to => "\"#{user.name}\" <#{user.email}>", :subject => "Thanks for your bracket entry")
  end

  def come_back(user)
    @user = user
    mail(:to => "\"#{user.name}\" <#{user.email}>", :subject => "Fill out your #{ENV['TOURNEY_NAME']} Bracket!")
  end
end
