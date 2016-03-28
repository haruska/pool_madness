module PossibilitiesHelper
  def cache_key_for_possibilities(pool)
    "pool-#{pool.id}/possibilities/#{pool.tournament.num_games_remaining}"
  end

  def all_outcomes_by_winners(outcome_set, pool)
    all_outcomes_hash = outcome_set.all_outcomes.each_with_object({}) do |outcome, winners_champ_hash|
      championship = outcome.tree.championship
      best_possible = outcome.best_possible_by_rank(pool)

      winners_champ_hash[best_possible] ||= []
      winners_champ_hash[best_possible] << championship
    end

    all_outcomes_hash.sort_by { |_, championships| championships.size }.reverse
  end
end
