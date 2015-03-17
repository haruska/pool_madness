class BracketScoreJob < ActiveJob::Base
  queue_as :default

  def perform(bracket_id)
    bracket = Bracket.find(bracket_id)
    bracket.calculate_points
    bracket.calculate_possible_points
  end
end
