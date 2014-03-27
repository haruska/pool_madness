class Contact
  include ActiveAttr::Model

  attribute :name
  attribute :email

  def self.session
    GoogleDrive.login(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
  end

  def self.all
    ws = session.spreadsheet_by_key(ENV['CONTACTS_SPREADSHEET_KEY']).worksheets[0]
    ws.rows[1..-1].collect do |row|
      new :name => "#{row[0]} #{row[1]}", :email => row[2]
    end
  end

  #Overwrite people's names with what is in the sheet
  def self.update_user_names(execute = false)
    contacts = self.all

    User.all.each do |user|
      contact = contacts.find {|x| x.email == user.email}
      if contact.present? && contact.name != user.name
        puts "Changing #{contact.email} name from #{user.name} to #{contact.name}"

        user.update_attribute(:name, contact.name) if execute
      end
    end
  end

  def invite
    ContactMailer.invite(self).deliver
  end
end
