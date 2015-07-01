class Tournament < ActiveRecord::Base
  has_many :games, dependent: :destroy
  has_many :pools, dependent: :destroy
  has_many :teams, dependent: :destroy

  accepts_nested_attributes_for :teams

  validates :name, presence: true, uniqueness: true

  def started?
    DateTime.now > tip_off
  end

  def start_eliminating?
    games.not_played.count < 16
  end

  def championship
    game = games.first
    game = game.next_game while game.next_game.present?
    game
  end

  def num_games
    2**num_rounds - 1
  end

  def round_for(round_number, region = nil)
    case round_number
    when num_rounds - 1
      [championship.game_two, championship.game_one]
    when num_rounds
      [championship]
    when 1
      sort_order = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]
      t = region.present? ? teams.where(region: region) : teams.all

      t.collect(&:first_game).uniq.sort_by { |x| sort_order.index(x.first_team.seed) }
    else
      round_for(round_number - 1, region).collect(&:next_game).uniq
    end
  end
end
