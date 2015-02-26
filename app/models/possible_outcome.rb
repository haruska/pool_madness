class PossibleOutcome
  include ActiveAttr::Model

  attribute :possible_outcome_set
  attribute :slot_bits
  attribute :possible_games, type: Hash

  delegate :tournament, :pool, :games, :brackets, :teams, to: :possible_outcome_set

  def create_possible_game(game_hash)
    possible_game = PossibleGame.new(game_hash.merge(possible_outcome: self))
    self.possible_games ||= {}
    self.possible_games[possible_game.game.id] = possible_game
  end

  def championship
    possible_game = possible_games.values.first
    possible_game = possible_game.next_game while possible_game.next_game.present?
    possible_game
  end

  def round_for(round_number, region = nil)
    tournament.round_for(round_number, region).map { |game| possible_games[game.id] }
  end

  def sorted_brackets
    result = brackets.map do |bracket|
      points = bracket.picks.map do |pick|
        possible_games[pick.game_id].points_for_pick(pick.team_id)
      end.sum
      [bracket, points]
    end

    result.sort_by(&:last).reverse
  end

  def update_brackets_best_possible
    sorted_brackets = self.sorted_brackets

    third_place_index = 2
    third_place_points = sorted_brackets[third_place_index][1]
    while sorted_brackets[third_place_index + 1][1] == third_place_points
      third_place_index += 1
    end

    sorted_brackets[0..third_place_index].each do |bracket, points|
      index = sorted_brackets.index { |_b, p| p == points }
      bracket.reload
      if bracket.best_possible > index
        bracket.best_possible = index
        bracket.save!
      end
    end
  end
end
