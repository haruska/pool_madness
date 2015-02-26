# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by(name: role)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
user = User.create_with(name: ENV['ADMIN_NAME'].dup, password: ENV['ADMIN_PASSWORD'].dup, password_confirmation: ENV['ADMIN_PASSWORD'].dup).find_or_create_by(email: ENV['ADMIN_EMAIL'].dup)
puts 'user: ' << user.name
user.add_role :admin

FactoryGirl.create(:pool)
