module PossibilitiesHelper
  def cache_key_for_possibilities(pool)
    "pool-#{pool.id}/possibilities/#{pool.tournament.num_games_remaining}"
  end
end
