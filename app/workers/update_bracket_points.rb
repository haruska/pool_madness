class UpdateBracketPoints
  include Sidekiq::Worker

  def perform(bracket_id)
    b = Bracket.find_by_id(bracket_id)

    b.calculate_points
    b.calculate_possible_points
  end
end