DatabaseCleaner.clean_with :truncation

admin = User.create_with(name: ENV['ADMIN_NAME'].dup, password: ENV['ADMIN_PASSWORD'].dup, password_confirmation: ENV['ADMIN_PASSWORD'].dup).find_or_create_by(email: ENV['ADMIN_EMAIL'].dup)
admin.admin!
puts "admin user: #{admin.name}"

user = User.create_with(name: 'Regular User', password: 'changeme', password_confirmation: 'changeme').find_or_create_by(email: 'user@pool-madness.com')
puts "regular user: #{user.name}"

completed = FactoryGirl.create(:tournament, :completed, name: "Completed Tourney")
final_four = FactoryGirl.create(:tournament, :in_final_four, name: "Final Four Tourney")
two_rounds = FactoryGirl.create(:tournament, :with_first_two_rounds_completed, name: "Two Rounds Completed Tourney")
not_started = FactoryGirl.create(:tournament, :not_started, name: "Unstarted Tourney")

Tournament.all.each do |tournament|
  puts "creating 2 pools for tournament #{tournament.id}"
  FactoryGirl.create_list(:pool, 2, tournament: tournament)
end

Pool.all.each do |pool|
  puts "creating admin for pool #{pool.id}"
  pool_user = FactoryGirl.create(:pool_user, pool: pool)
  pool_user.admin!

  #adding known regular user to pool
  FactoryGirl.create(:pool_user, pool: pool, user: user)

  puts "creating 5 regular users for pool #{pool.id}"
  FactoryGirl.create_list(:pool_user, 5, pool: pool)

  pool.users.each do |user|
    puts "creating a completed bracket for pool/user #{pool.id}/#{user.id}"
    FactoryGirl.create(:bracket, :completed, user: user, pool: pool)
  end
end

Bracket.all.each { |b| b.paid! }

puts "updating pool-admin and user email addresses"
PoolUser.admin.first.user.update!(email: "pool-admin@pool-madness.com")

puts "creating unpaid brackets"
not_started.pools.each do |pool|
  FactoryGirl.create_list(:bracket, 2, :completed, user: user, pool: pool)
end

puts "creating championship brackets"
final_four.pools.each do |pool|
  pool.users.each do |user|
    bracket = FactoryGirl.create(:bracket, :completed, user: user, pool: pool)
    bracket.tree_decisions = final_four.game_decisions
    bracket.bracket_point.update(best_possible: 0)
    3.times { |i| bracket.update_choice(i+1, [0,1].sample) }
    bracket.save!
  end
end

Bracket.find_each do |bracket|
  bracket.calculate_points
  bracket.calculate_possible_points
end