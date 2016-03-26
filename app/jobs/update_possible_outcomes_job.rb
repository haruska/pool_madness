class UpdatePossibleOutcomesJob < ActiveJob::Base
  queue_as :default

  def perform(tournament_id, opts = {})
    tournament = Tournament.find(tournament_id)
    outcome_set = PossibleOutcomeSet.new(tournament: tournament)
    max_variable_bits = outcome_set.to_play_games_mask
    variable_bits = 0

    bracket_ranks = {}

    until variable_bits > max_variable_bits
      outcome = outcome_set.outcome_for(outcome_set.slot_bits_for(variable_bits))

      tournament.pools.each do |pool|
        outcome.get_best_possible(pool).each do |bracket, rank|
          if bracket_ranks[bracket.id].nil?
            bracket_ranks[bracket.id] = rank
          elsif bracket_ranks[bracket.id] > rank
            bracket_ranks[bracket.id] = rank
          end
        end
      end

      variable_bits += 1
    end

    tournament.pools.each do |pool|
      pool.bracket_points.update_all(best_possible: 60_000)
    end

    bracket_ranks.each do |bracket_id, rank|
      Bracket.find(bracket_id).bracket_point.update!(best_possible: rank)
    end
  end

  def self.outcome_set_key(tournament_id, timestamp)
    "outcomeset_#{tournament_id}_#{timestamp}"
  end
end