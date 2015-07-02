class GameNode < BinaryDecisionTree::Node
  def round
    current_depth
  end

  def next_slot
    return nil unless parent.present?
    parent.left == self ? LEFT + 1 : RIGHT + 1
  end

  def next_game_slot
    parent_position == 0 ? nil : parent_position
  end

  def game
    tree.tournament.tree.at(slot)
  end

  def team_one
    return nil unless leaf?
    tree.tournament.teams.find_by(starting_slot: left_position)
  end

  def team_two
    return nil unless leaf?
    tree.tournament.teams.find_by(starting_slot: right_position)
  end

  def game_one
    left
  end

  def game_two
    right
  end

  def next_game
    parent
  end

  def first_team
    team_one || tree.tournament.teams.find_by(starting_slot: left.try(:value))
  end

  def second_team
    team_two || tree.tournament.teams.find_by(starting_slot: right.try(:value))
  end

  def team
    tree.tournament.teams.find_by(starting_slot: value)
  end

  def points(possible_game = nil)
    this_game = possible_game || game

    if value.present? && this_game.value == value
      BracketPoint::POINTS_PER_ROUND[round] + team.seed
    else
      0
    end
  end

  def possible_points
    if game.value.blank? && team.try(:still_playing?)
      BracketPoint::POINTS_PER_ROUND[round] + team.seed
    else
      points
    end
  end
end