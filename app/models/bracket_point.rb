class BracketPoint < ActiveRecord::Base
  belongs_to :bracket

  delegate :picks, to: :bracket

  def calculate_possible_points
    points_calc = picks.collect(&:possible_points).sum
    update!(possible_points: points_calc)
    points_calc
  end

  def calculate_points
    points_calc = picks.collect(&:points).sum
    update!(points: points_calc)
    points_calc
  end
end
