class PossibleGame < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :possible_outcome
  belongs_to :game

  belongs_to :game_one, :class_name => PossibleGame
  belongs_to :game_two, :class_name => PossibleGame

  delegate :team_one, :team_two, :to => :game

  attr_accessible :game_id, :score_one, :score_two, :game_one_id, :game_two_id

  def first_team
    self.game.team_one || self.game_one.winner
  end

  def second_team
    self.game.team_two || self.game_two.winner
  end

  def winner
    score_one > score_two ? first_team : second_team
  end

  def next_game
    PossibleGame.where(:game_one_id => self.id).first || PossibleGame.where(:game_two_id => self.id).first
  end

  #returns 1, 2 or nil
  def next_slot
    [0, next_game.game_one_id, next_game.game_two_id].index(self.id)
  end

  def round
    round = 6 #championship
    n = self.next_game
    while n.present?
      round -= 1
      n = n.next_game
    end
    round
  end
end
