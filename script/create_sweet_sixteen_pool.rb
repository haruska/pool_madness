sixty_four_tournament = Tournament.find_by name: Time.current.year.to_s + " NCAA March Madness Tournament"

tournament = Tournament.create(
  name: Time.current.year.to_s + " NCAA Sweet Sixteen",
  tip_off: sixty_four_tournament.tip_off + 1.week,
  num_rounds: 4
)

sixty_four_tournament.round_for(3).each do |game|
  [game.first_team, game.second_team].each_with_index do |team, i|
    tournament.teams.create(
      region: team.region,
      seed: team.seed,
      name: team.name,
      score_team_id: team.score_team_id,
      starting_slot: i.zero? ? game.left_position : game.right_position
    )
  end
end

sixty_four_tournament.pools.each do |previous_pool|
  invite_code = previous_pool.invite_code
  previous_pool.update!(invite_code: Pool.generate_unique_code)
  pool = tournament.pools.create(name: previous_pool.name + " Sweet 16", invite_code: invite_code)

  previous_pool.pool_users.each do |pool_user|
    pool.pool_users.create(user_id: pool_user.user_id, role: pool_user.role)
  end
end
