class Tournament < ActiveRecord::Base
  has_many :games
  has_many :pools
  has_many :teams

  accepts_nested_attributes_for :teams

  validates :name, presence: true, uniqueness: true

  def started?
    DateTime.now > tip_off
  end

  def start_eliminating?
    DateTime.now > (tip_off + eliminating_offset).in_time_zone("America/New_York").at_midnight
  end

  def championship
    game = games.first
    game = game.next_game while game.next_game.present?
    game
  end

  def round_for(round_number, region = nil)
    case round_number
      when num_rounds - 1
        [championship.game_two, championship.game_one]
      when num_rounds
        [championship]
      when 1
        sort_order = [1, 8, 5, 4, 6, 3, 7, 2]
        t = region.present? ? teams.where(region: region) : teams.all

        t.collect(&:first_game).uniq.sort_by { |x| sort_order.index(x.first_team.seed) }
      else
        round_for(round_number - 1, region).collect(&:next_game).uniq
    end
  end
end
