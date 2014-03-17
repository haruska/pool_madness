# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.add_role :admin

{
    Team::MIDWEST => [
        'Wichita St',
        'Michigan',
        'Duke',
        'Louisville',
        'St Louis',
        'UMass',
        'Texas',
        'Kentucky',
        'Kansas St',
        'Arizona St',
        'Play-In MW11',
        'Play-In MW12',
        'Manhattan',
        'Mercer',
        'Wofford',
        'Play-In MW16'
    ],
    Team::WEST => [
        'Arizona',
        'Wisconsin',
        'Creighton',
        'San Diego St',
        'Oklahoma',
        'Baylor',
        'Oregon',
        'Gonzaga',
        'Oklahoma St',
        'BYU',
        'Nebraska',
        'N Dakota St',
        'New Mex St',
        'UL-Lafayette',
        'American',
        'Weber St'
    ],
    Team::SOUTH => [
        'Florida',
        'Kansas',
        'Syracuse',
        'UCLA',
        'VCU',
        'Ohio St',
        'New Mexico',
        'Colorado',
        'Pittsburgh',
        'Stanford',
        'Dayton',
        'SF Austin',
        'Tulsa',
        'W Michigan',
        'E Kentucky',
        'Play-In S16'
    ],
    Team::EAST => [
        'Virginia',
        'Villanova',
        'Iowa St',
        'Michigan St',
        'Cincinnati',
        'N Carolina',
        'Connecticut',
        'Memphis',
        'George Wash',
        'St Joes',
        'Providence',
        'Harvard',
        'Delaware',
        'NC Central',
        'UW Milwaukee',
        'Coast Car'
    ]
}.each do |region, team_names|
  team_names.each_with_index do |name, i|
    Team.create :region => region, :seed => i+1, :name => name
  end
end

Team::REGIONS.each do |region|
  #64 teams
  i, j = 1, 16
  while i < j
    team_one = Team.find_by_region_and_seed(region, i)
    team_two = Team.find_by_region_and_seed(region, j)
    Game.create :team_one => team_one, :team_two => team_two
    i += 1
    j -= 1
  end

  #32 teams
  [[1,8], [5,4], [6,3], [7,2]].each do |one, two|
    game_one = Game.find_by_team_one_id(Team.find_by_region_and_seed(region, one))
    game_two = Game.find_by_team_one_id(Team.find_by_region_and_seed(region, two))
    Game.create :game_one => game_one, :game_two => game_two
  end

  #Sweet 16
  [[1,5], [6, 7]].each do |one, two|
    game_one = Game.find_by_team_one_id(Team.find_by_region_and_seed(region, one)).next_game
    game_two = Game.find_by_team_one_id(Team.find_by_region_and_seed(region, two)).next_game
    Game.create :game_one => game_one, :game_two => game_two
  end

  #Great 8
  game_one = Game.find_by_team_one_id(Team.find_by_region_and_seed(region, 1)).next_game.next_game
  game_two = Game.find_by_team_one_id(Team.find_by_region_and_seed(region, 6)).next_game.next_game
  Game.create :game_one => game_one, :game_two => game_two
end

#Final 4
game_one = Game.find_by_team_one_id(Team.find_by_region_and_seed(Team::MIDWEST, 1)).next_game.next_game.next_game
game_two = Game.find_by_team_one_id(Team.find_by_region_and_seed(Team::WEST, 1)).next_game.next_game.next_game
champ_one = Game.create :game_one => game_one, :game_two => game_two

game_one = Game.find_by_team_one_id(Team.find_by_region_and_seed(Team::SOUTH, 1)).next_game.next_game.next_game
game_two = Game.find_by_team_one_id(Team.find_by_region_and_seed(Team::EAST, 1)).next_game.next_game.next_game
champ_two = Game.create :game_one => game_one, :game_two => game_two

#Championship
Game.create :game_one => champ_one, :game_two => champ_two
