class BracketPoint < ActiveRecord::Base
  POINTS_PER_ROUND = [0, 1, 2, 3, 5, 8, 13]

  belongs_to :bracket

  def calculate_possible_points
    working_tree = bracket.tree
    points_calc = (1..bracket.tournament.num_games).map {|slot| working_tree.at(slot).possible_points }.sum
    update!(possible_points: points_calc)
    points_calc
  end

  def calculate_points
    working_tree = bracket.tree
    points_calc = (1..bracket.tournament.num_games).map {|slot| working_tree.at(slot).points }.sum
    update!(points: points_calc)
    points_calc
  end
end
