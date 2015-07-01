class GameNode < BinaryDecisionTree::Node
  def next_slot
    return nil unless parent.present?
    parent.left == self ? LEFT + 1 : RIGHT + 1
  end

  def next_game_slot
    parent_position == 0 ? nil : parent_position
  end

  def game
    tree.tournament.games.find_by(slot: slot)
  end

  def team_one
    return nil unless leaf?
    tree.tournament.teams.find_by(starting_slot: left_position)
  end

  def team_two
    return nil unless leaf?
    tree.tournament.teams.find_by(starting_slot: right_position)
  end

  def first_team
    tree.tournament.teams.find_by(starting_slot: left.value)
  end

  def second_team
    tree.tournament.teams.find_by(starting_slot: right.value)
  end

  def team
    tree.tournament.teams.find_by(starting_slot: value)
  end

  def points(possible_game = nil)
    this_game = possible_game || game

    if team.present? && this_game.winner.present? && team == this_game.winner
      BracketPoint::POINTS_PER_ROUND[this_game.round] + team.seed
    else
      0
    end
  end

  def possible_points
    if game.winner.blank? && team.try(:still_playing?)
      BracketPoint::POINTS_PER_ROUND[game.round] + team.seed
    else
      points
    end
  end
end