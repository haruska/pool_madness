class Newsletter < ActionMailer::Base
  default from: "admin@pool-madness.com"

  def home_page_email(email_entered)
    @email_entered = email_entered
    mail(:to => 'admin@pool-madness.com', :subject => 'Pool Madness Subscriber')
  end
end
