sixty_four_tournament = Tournament.find_by name: Time.now.year.to_s + " NCAA March Madness Tournament"

tournament = Tournament.create(
    name: Time.now.year.to_s + " NCAA Sweet Sixteen",
    tip_off: sixty_four_tournament.tip_off + 1.week,
    num_rounds: 4
)


sixty_four_tournament.rounds.where("number > ?", 2).order(:number).each_with_index do |sf_round, i|
  tournament.rounds.create(
      number: i + 1,
      name: sf_round.name,
      start_date: sf_round.start_date,
      end_date: sf_round.end_date
  )
end

sixty_four_tournament.round_for(3).each do |game|
  [game.first_team, game.second_team].each_with_index do |team, i|
    tournament.teams.create(
                        region: team.region,
                        seed: team.seed,
                        name: team.name,
                        score_team_id: team.score_team_id,
                        starting_slot: i == 0 ? game.left_position : game.right_position
    )
  end
end


sixty_four_tournament.pools.each do |previous_pool|
  pool = tournament.pools.create(name: previous_pool.name + " Sweet 16")

  previous_pool.pool_users.each do |pool_user|
    pool.pool_users.create(user_id: pool_user.user_id, role: pool_user.role)
  end
end
