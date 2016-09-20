class Game < BinaryDecisionTree::Node
  alias game_one left
  alias game_two right
  alias next_game parent
  alias id slot

  def round
    rounds = (1..tournament_tree.depth).to_a.reverse
    rounds[current_depth - 1]
  end

  def championship?
    parent_position.zero?
  end

  def tournament_game
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

  alias winner team

  def loser
    return nil unless winner.present?
    ([first_team, second_team] - [winner]).first
  end

  def points(possible_game = nil)
    working_game = possible_game || tournament_game

    if value.present? && working_game.value == value
      BracketPoint::POINTS_PER_ROUND[round] + team_seed
    else
      0
    end
  end

  def possible_points
    if tournament_game.value.blank? && team.try(:still_playing?)
      BracketPoint::POINTS_PER_ROUND[round] + team_seed
    else
      points
    end
  end

  def ==(other)
    other.class == self.class && other.tree == tree && other.slot == slot && other.value == value
  end

  alias eql? ==

  private

  def team_seed
    tournament.team_seed(value)
  end

  def team_by_slot(in_slot)
    slot_number = in_slot.try(:value) || in_slot

    teams_hash = Rails.cache.fetch("team_by_slot_teams_hash_" + tournament.id.to_s) do
      tournament.teams.each_with_object({}) do |ele, acc|
        acc[ele.starting_slot] = ele
      end
    end

    teams_hash[slot_number]
  end

  def tournament
    tree.tournament
  end

  def tournament_tree
    tournament.tree
  end
end
