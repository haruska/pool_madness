tournament = Tournament.find(35)
pool = tournament.pools.find(38)

outcome_set = PossibleOutcomeSet.new(tournament: tournament)
max_variable_bits = outcome_set.to_play_games_mask

variable_bits = 0

bracket_winner_hash = {}

until variable_bits > max_variable_bits
  outcome = outcome_set.outcome_for(outcome_set.slot_bits_for(variable_bits))
  winners = (1..tournament.num_games_remaining).map do |slot|
    outcome.tree.at(slot).team.name
  end

  final_four_str = winners.uniq.reverse.join(", ")

  brackets = outcome.get_best_possible(pool).select do |_, rank|
    rank == 0
  end.map {|bracket, _| bracket.name}

  bracket_str = brackets.sort.join(", ")

  bracket_winner_hash[bracket_str] ||= []
  bracket_winner_hash[bracket_str] << final_four_str

  variable_bits += 1
end

bracket_winner_hash.keys.sort.each do |bracket_str|
  puts bracket_str
  puts '========================================='
  winners_arr = bracket_winner_hash[bracket_str]
  winners_arr.sort.each do |final_four_str|
    puts final_four_str
  end
  puts
  puts
end