class BracketMailer < ActionMailer::Base
  default from: "\"#{ENV['ADMIN_NAME']}\" <#{ENV['ADMIN_EMAIL']}>"

  def unpaid(bracket)
    @bracket = bracket
    @user = bracket.user
    mail(:to => "\"#{@user.name}\" <#{@user.email}>", :subject => "Unpaid Bracket: #{bracket.name}")
  end

  def incomplete(bracket)
    @bracket = bracket
    @user = bracket.user
    mail(:to => "\"#{@user.name}\" <#{@user.email}>", :subject => "Incomplete Bracket: #{bracket.name}")
  end
end
