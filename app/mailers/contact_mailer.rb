class ContactMailer < ActionMailer::Base
  default from: "\"#{ENV['ADMIN_NAME']}\" <#{ENV['ADMIN_EMAIL']}>"

  def invite(contact)
    @contact = contact
    mail(:to => "\"#{@contact.name}\" <#{@contact.email}>", :subject => "#{ENV['TOURNEY_NAME']} Bracket")
  end
end
