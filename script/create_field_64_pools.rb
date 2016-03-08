name_suffix = " NCAA March Madness Tournament"
previous_tournament_name = 1.year.ago.year.to_s + name_suffix
previous_tournament = Tournament.find_by name: previous_tournament_name

tournament = Tournament.create(
    name: Time.now.year.to_s + name_suffix,
    num_rounds: 6,
    tip_off: Time.parse("March 17, #{Time.now.year} 16:00 UTC")
)

[
    { name: "FIELD 64", start: "March 17", end: "March 18" },
    { name: "FIELD 32", start: "March 19", end: "March 20" },
    { name: "SWEET 16", start: "March 24", end: "March 25" },
    { name: "ELITE EIGHT", start: "March 26", end: "March 27" },
    { name: "FINAL FOUR", start: "April 2", end: "April 2" },
    { name: "CHAMPION", start: "April 4", end: "April 4" },
].each_with_index do |round, i|
  tournament.rounds.create(
      number: i + 1,
      name: round[:name],
      start_date: Time.parse("#{round[:start]}, #{Time.now.year} 12:00 UTC"),
      end_date: Time.parse("#{round[:end]}, #{Time.now.year} 12:00 UTC")
  )
end

team_name_hash = {
    Team::SOUTH => [
        "Florida",
        "Kansas",
        "Syracuse",
        "UCLA",
        "VCU",
        "Ohio St",
        "New Mexico",
        "Colorado",
        "Pittsburgh",
        "Stanford",
        "Dayton",
        "SF Austin",
        "Tulsa",
        "W Michigan",
        "E Kentucky",
        "Play-In S16"
    ],
    Team::EAST => [
        "Virginia",
        "Villanova",
        "Iowa St",
        "Michigan St",
        "Cincinnati",
        "N Carolina",
        "Connecticut",
        "Memphis",
        "George Wash",
        "St Joes",
        "Providence",
        "Harvard",
        "Delaware",
        "NC Central",
        "UW Milwaukee",
        "Coast Car"
    ],
    Team::WEST => [
        "Arizona",
        "Wisconsin",
        "Creighton",
        "San Diego St",
        "Oklahoma",
        "Baylor",
        "Oregon",
        "Gonzaga",
        "Oklahoma St",
        "BYU",
        "Nebraska",
        "N Dakota St",
        "New Mex St",
        "UL-Lafayette",
        "American",
        "Weber St"
    ],
    Team::MIDWEST => [
        "Wichita St",
        "Michigan",
        "Duke",
        "Louisville",
        "St Louis",
        "UMass",
        "Texas",
        "Kentucky",
        "Kansas St",
        "Arizona St",
        "Play-In MW11",
        "Play-In MW12",
        "Manhattan",
        "Mercer",
        "Wofford",
        "Play-In MW16"
    ]
}


team_name_hash.each do |region, team_names|
  team_names.each_with_index do |name, i|
    tournament.teams.create region: region, seed: i + 1, name: name
  end
end

team_slot = tournament.teams.count

sort_order = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]

team_name_hash.keys.each do |region|
  sort_order.each_slice(2) do |i, j|
    team_one = tournament.teams.find_by(region: region, seed: i)
    team_two = tournament.teams.find_by(region: region, seed: j)

    team_one.update(starting_slot: team_slot)
    team_two.update(starting_slot: team_slot + 1)

    team_slot += 2
  end
end

previous_tournament.pools.each do |previous_pool|
  pool = tournament.pools.create(name: previous_pool.name)

  previous_pool.pool_users.each do |pool_user|
    pool.pool_users.create(user_id: pool_user.user_id, role: pool_user.role)
  end
end