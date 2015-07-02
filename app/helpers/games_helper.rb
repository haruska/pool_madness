module GamesHelper
  def cache_key_for_tournament_bracket(tournament)
    "tournament-#{tournament.id}/games/all-#{tournament.updated_at}"
  end
end
