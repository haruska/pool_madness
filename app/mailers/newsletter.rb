class Newsletter < ActionMailer::Base
  default from: "\"#{ENV['ADMIN_NAME']}\" <#{ENV['ADMIN_EMAIL']}>"

  def home_page_email(email_entered)
    @email_entered = email_entered
    mail(:to => 'admin@pool-madness.com', :subject => 'Pool Madness Subscriber')
  end
end
