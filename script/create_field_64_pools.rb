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
        "Kansas",
        "Villanova",
        "Miami",
        "California",
        "Maryland",
        "Arizona",
        "Iowa",
        "Colorado",
        "UConn",
        "Temple",
        "PlayIn S11",
        "S Dak St",
        "Hawaii",
        "Buffalo",
        "UNC-Ash",
        "Austin Py"
    ],
    Team::WEST => [
        "Oregon",
        "Oklahoma",
        "Texas A&M",
        "Duke",
        "Baylor",
        "Texas",
        "Oregon St",
        "St Joe's",
        "Cincinnati",
        "VCU",
        "N Iowa",
        "Yale",
        "UNC Wilm",
        "Green Bay",
        "Cal Baker",
        "PlayIn W16"
    ],
    Team::EAST => [
        "N Carolina",
        "Xaiver",
        "W Virginia",
        "Kentucky",
        "Indiana",
        "Notre Dame",
        "Wisconsin",
        "USC",
        "Providence",
        "Pittsburgh",
        "PlayIn E11",
        "Chattanooga",
        "Stony Brook",
        "SF Austin",
        "Weber St",
        "PlayIn E16"
    ],
    Team::MIDWEST => [
        "Virginia",
        "Michigan St",
        "Utah",
        "Iowa St",
        "Purdue",
        "Seton Hall",
        "Dayton",
        "Texas Tech",
        "Butler",
        "Syracuse",
        "Gonzaga",
        "Little Rock",
        "Iona",
        "Fresno St",
        "Mid Tenn",
        "Hampton"
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