class PossibleOutcome
  include ActiveAttr::Model

  attribute :possible_outcome_set
  attribute :possible_games, type: Hash

  delegate :tournament, :games, :teams, :round_for_cache, :pool_brackets_cache, :bracket_picks_cache, to: :possible_outcome_set

  def create_or_update_possible_game(game_hash)
    self.possible_games ||= {}

    game = game_hash[:game]

    if possible_games[game.id].nil?
      possible_game = PossibleGame.new(game_hash.merge(possible_outcome: self))
      self.possible_games[game.id] = possible_game
    else
      possible_game = possible_games[game.id]
    end

    possible_game.update_score(game_hash[:score_one], game_hash[:score_two])

    possible_game
  end

  def championship
    possible_game = possible_games.values.first
    possible_game = possible_game.next_game while possible_game.next_game.present?
    possible_game
  end

  def round_for(round_number, region = nil)
    round_for_cache(round_number, region).map { |game| possible_games[game.id] }
  end

  def sorted_brackets(pool)
    result = pool_brackets_cache(pool).map do |bracket|
      points = bracket_picks_cache(bracket).map do |pick|
        possible_games[pick.game_id].points_for_pick(pick.team_id)
      end.sum
      [bracket, points]
    end

    result.sort_by(&:last).reverse
  end

  def get_best_possible(pool)
    s_brackets = sorted_brackets(pool)

    third_place_index = 2
    third_place_points = s_brackets[third_place_index][1]
    while s_brackets[third_place_index + 1][1] == third_place_points
      third_place_index += 1
    end

    s_brackets[0..third_place_index].map do |bracket, points|
      index = s_brackets.index { |_b, p| p == points }
      [bracket, index]
    end
  end
end
