module GamesHelper
  def cache_key_for_tournament_bracket(tournament)
    max_updated_at = tournament.games.maximum(:updated_at).to_i
    "tournament-#{tournament.id}/games/all-#{max_updated_at}"
  end
end