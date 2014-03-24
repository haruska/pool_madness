class PossibleGame < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :possible_outcome
  belongs_to :game

  belongs_to :game_one, :class_name => PossibleGame
  belongs_to :game_two, :class_name => PossibleGame

  delegate :team_one, :team_two, :to => :game

  attr_accessible :game_id, :score_one, :score_two, :game_one_id, :game_two_id

  after_destroy do |possible_game|
    Rails.cache.delete("possible_game_first_team_#{self.id}")
    Rails.cache.delete("possible_game_second_team_#{self.id}")
    Rails.cache.delete("possible_game_round_#{self.id}")
  end

  def first_team
    Rails.cache.fetch("possible_game_first_team_#{self.id}") do
      self.game.team_one || self.game_one.winner
    end
  end

  def second_team
    Rails.cache.fetch("possible_game_second_team_#{self.id}") do
      self.game.team_two || self.game_two.winner
    end
  end

  def winner
    score_one > score_two ? first_team : second_team
  end

  def next_game
    PossibleGame.where(:game_one_id => self.id).first || PossibleGame.where(:game_two_id => self.id).first
  end

  def points_for_pick(team_id)
    team_id == winner.id ? Pick::POINTS_PER_ROUND[round] + winner.seed : 0
  end

  #returns 1, 2 or nil
  def next_slot
    [0, next_game.game_one_id, next_game.game_two_id].index(self.id)
  end

  def round
    Rails.cache.fetch("possible_game_round_#{self.id}") do
      round = 6 #championship
      n = self.next_game
      while n.present?
        round -= 1
        n = n.next_game
      end
      round
    end
  end
end
