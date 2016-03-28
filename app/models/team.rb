class Team < ActiveRecord::Base
  SOUTH = "South".freeze
  WEST = "West".freeze
  EAST = "East".freeze
  MIDWEST = "Midwest".freeze

  REGIONS = [SOUTH, WEST, EAST, MIDWEST].freeze

  belongs_to :tournament

  validates :name, uniqueness: { scope: :tournament_id }, length: { maximum: 15 }

  validates :region, inclusion: { in: [SOUTH, WEST, EAST, MIDWEST] }

  validates :seed,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 16 },
            uniqueness: { scope: [:tournament_id, :region] }

  def first_game
    tournament.tree.at(starting_slot / 2)
  end

  def still_playing?
    game = first_game
    while game.present? && !game.decision.nil?
      return false if game.value != starting_slot
      game = game.parent
    end
    true
  end

  def eliminated?
    !still_playing?
  end
end
