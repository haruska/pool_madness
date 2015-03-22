
haruska_pool = Pool.find_by name: "Haruska"
haruska_tournament = haruska_pool.tournament

tournament = Tournament.create(name: "2015 NCAA Sweet Sixteen", tip_off: haruska_tournament.tip_off + 1.week)

game_map = {}

haruska_tournament.round_for(3).each do |game|
  teams = [game.first_team, game.second_team].map do |team|

    tournament.teams.create(name: team.name,
                            score_team_id: team.score_team_id,
                            seed: team.seed,
                            region: team.region)
  end

  g = tournament.games.create(team_one_id: teams.first.id, team_two_id: teams.second.id)
  game_map[game.id] = g.id
end

(4..6).each do |round_num|
  haruska_tournament.round_for(round_num).each do |game|
    g = tournament.games.create(game_one_id: game_map[game.game_one_id], game_two_id: game_map[game.game_two_id])
    game_map[game.id] = g.id
  end
end

pool = Pool.create(name: "Sweet 16", tournament: tournament)

haruska_pool.pool_users.each do |pool_user|
  pool.pool_users.create(user_id: pool_user.user_id, role: pool_user.role)
end