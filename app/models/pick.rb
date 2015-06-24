class Pick < ActiveRecord::Base
  POINTS_PER_ROUND = [0, 1, 2, 3, 5, 8, 13]

  belongs_to :bracket
  belongs_to :game

  validates :bracket, :game, presence: true

  def first_team
    if game.game_one.present?
      bracket.picks.find_by(game_id: game.game_one_id).try(:team)
    else
      game.team_one
    end
  end

  def second_team
    if game.game_two.present?
      bracket.picks.find_by(game_id: game.game_two_id).try(:team)
    else
      game.team_two
    end
  end

  def team
    case choice
      when 0
        first_team
      when 1
        second_team
      else
        nil
    end
  end

  def points(possible_game = nil)
    this_game = possible_game || game

    if team.present? && this_game.winner.present? && team == this_game.winner
      POINTS_PER_ROUND[this_game.round] + team.seed
    else
      0
    end
  end

  def possible_points
    if game.winner.blank? && team.try(:still_playing?)
      POINTS_PER_ROUND[game.round] + team.seed
    else
      points
    end
  end
end
