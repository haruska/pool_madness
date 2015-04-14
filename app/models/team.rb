class Team < ActiveRecord::Base
  SOUTH = "South"
  WEST = "West"
  EAST = "East"
  MIDWEST = "Midwest"

  REGIONS = [SOUTH, EAST, WEST, MIDWEST]

  belongs_to :tournament

  validates :name, uniqueness: { scope: :tournament_id }, length: { maximum: 15 }

  validates :region, inclusion: { in: [SOUTH, WEST, EAST, MIDWEST] }

  validates :seed,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 16 },
            uniqueness: { scope: [:tournament_id, :region] }

  def first_game
    tournament.games.find_by(team_one_id: id) || tournament.games.find_by(team_two_id: id)
  end

  def still_playing?
    game = first_game
    while game.try(:winner).present?
      return false if game.winner != self
      game = game.next_game
    end
    true
  end

  def eliminated?
    !still_playing?
  end
end
