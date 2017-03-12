name_suffix = " NCAA March Madness Tournament"
previous_tournament_name = 1.year.ago.year.to_s + name_suffix
previous_tournament = Tournament.find_by name: previous_tournament_name

tournament = Tournament.create(
  name: Time.current.year.to_s + name_suffix,
  num_rounds: 6,
  tip_off: Time.parse("March 16, #{Time.current.year} 16:00 UTC").utc
)

team_name_hash = {
  Team::EAST => [
    "Villanova",
    "Duke",
    "Baylor",
    "Florida",
    "Virginia",
    "SMU",
    "S Carolina",
    "Wisconsin",
    "Va Tech",
    "Marquette",
    "PlayIn E11",
    "UNC-Wilm",
    "ETSU",
    "New Mex St",
    "Troy",
    "PlayIn E16"
  ],
  Team::WEST => [
    "Gonzaga",
    "Arizona",
    "Florida St",
    "W Virginia",
    "Notre Dame",
    "Maryland",
    "St Mary's",
    "NWestern",
    "Vanderbilt",
    "VCU",
    "Xavier",
    "Princeton",
    "Bucknell",
    "FGCU",
    "N Dakota",
    "S Dak St"
  ],
  Team::MIDWEST => [
    "Kansas",
    "Louisville",
    "Oregon",
    "Purdue",
    "Iowa St",
    "Creighton",
    "Michigan",
    "Miami",
    "Michigan St",
    "Oklahoma St",
    "Rhode Island",
    "Nevada",
    "Vermont",
    "Iona",
    "Jax St",
    "PlayIn MW16"
  ],
  Team::SOUTH => [
    "N Carolina",
    "Kentucky",
    "UCLA",
    "Butler",
    "Minnesota",
    "Cincinnati",
    "Dayton",
    "Arkansas",
    "Seton Hall",
    "Wichita St",
    "PlayIn S11",
    "Middle Tenn",
    "Winthrop",
    "Kent St",
    "N Kentucky",
    "Texas So"
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
