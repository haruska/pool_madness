class Pick < ActiveRecord::Base
  POINTS_PER_ROUND = [0, 1, 2, 3, 5, 8, 13]

  belongs_to :bracket
  belongs_to :team
  belongs_to :game

  attr_accessible :game_id, :team_id

  def first_team
    if self.game.game_one.present?
      self.bracket.picks.where(:game_id => self.game.game_one_id).first.try(:team)
    else
      self.game.team_one
    end
  end

  def second_team
    if self.game.game_two.present?
      self.bracket.picks.where(:game_id => self.game.game_two_id).first.try(:team)
    else
      self.game.team_two
    end
  end

  def points
    if self.team.present? && self.game.winner.present? && self.team == self.game.winner
      POINTS_PER_ROUND[self.game.round]
    else
      0
    end
  end

  def possible_points
    if self.game.winner.blank? && self.team.try(:still_playing?)
      POINTS_PER_ROUND[self.game.round]
    else
      self.points
    end
  end
end
