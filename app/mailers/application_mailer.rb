class ApplicationMailer < ActionMailer::Base
  default from: "\"#{ENV['ADMIN_NAME']}\" <#{ENV['ADMIN_EMAIL']}>"
  layout 'mailer'
end
