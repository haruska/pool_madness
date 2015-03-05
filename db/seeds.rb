
#DatabaseCleaner.clean_with :truncation


User.delete_all
Tournament.delete_all
PoolUser.delete_all
Pool.delete_all
Bracket.delete_all

user = User.create_with(name: ENV['ADMIN_NAME'].dup, password: ENV['ADMIN_PASSWORD'].dup, password_confirmation: ENV['ADMIN_PASSWORD'].dup).find_or_create_by(email: ENV['ADMIN_EMAIL'].dup)
user.admin!
puts "admin user: #{user.name}"

[4.days.from_now, 4.days.ago].each do |tip_off|
  puts "creating tournament with tip off #{tip_off}"
  FactoryGirl.create(:tournament, tip_off: tip_off)
end

Tournament.all.each do |tournament|
  puts "creating 2 pools for tournament #{tournament.id}"
  FactoryGirl.create_list(:pool, 2, tournament: tournament)
end

Pool.all.each do |pool|
  puts "creating admin for pool #{pool.id}"
  pool_user = FactoryGirl.create(:pool_user, pool: pool)
  pool_user.admin!

  puts "createing 5 regular users for pool #{pool.id}"
  FactoryGirl.create_list(:pool_user, 5, pool: pool)

  pool.users.each do |user|
    puts "creating a completed bracket for pool/user #{pool.id}/#{user.id}"
    FactoryGirl.create(:bracket, :completed, user: user, pool: pool)
  end
end

Bracket.all.each { |b| b.paid! }

puts "updating pool-admin and user email addresses"
PoolUser.admin.first.user.update!(email: "pool-admin@pool-madness.com")
PoolUser.regular.first.user.update!(email: "user@pool-madness.com")
