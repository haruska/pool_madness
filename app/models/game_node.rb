class GameNode < BinaryDecisionTree::Node
  alias_method :round, :current_depth
  alias_method :game_one, :left
  alias_method :game_two, :right
  alias_method :next_game, :parent

  def championship?
    parent_position == 0
  end

  def game
    tournament_tree.at(slot)
  end

  def next_slot
    return nil if championship?
    slot.even? ? 1 : 2
  end

  def next_game_slot
    championship? ? nil : parent_position
  end

  def team_one
    leaf? ? team_by_slot(left_position) : nil
  end

  def team_two
    leaf? ? team_by_slot(right_position) : nil
  end

  def first_team
    team_one || team_by_slot(left)
  end

  def second_team
    team_two || team_by_slot(right)
  end

  def team
    team_by_slot(self)
  end

  def points(possible_game = nil)
    game = possible_game || self

    if value.present? && game.value == value
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

  def ==(obj)
    obj.class == self.class && obj.tree == tree  && obj.slot == slot && obj.value == value
  end

  alias_method :eql?, :==

  private

  def team_by_slot(in_slot)
    slot_number = in_slot.try(:value) || in_slot
    tournament.teams.find_by(starting_slot: slot_number)
  end

  def tournament
    tree.tournament
  end

  def tournament_tree
    tournament.tree
  end
end