class Game < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :team_one, :class_name => Team
  belongs_to :team_two, :class_name => Team
  belongs_to :game_one, :class_name => Game
  belongs_to :game_two, :class_name => Game

  attr_accessible :team_one, :team_two, :game_one, :game_two, :score_one, :score_two

  def first_team
    self.team_one || self.game_one.winner
  end

  def second_team
    self.team_two || self.game_two.winner
  end

  def winner
    return nil if score_one.nil? || score_two.nil?
    score_one > score_two ? first_team : second_team
  end

  def next_game
    Game.where(:game_one_id => self.id).first || Game.where(:game_two_id => self.id).first
  end

  #returns 1, 2 or nil
  def next_slot
    [0, next_game.game_one_id, next_game.game_two_id].index(self.id)
  end

  def self.championship
    game = Game.first
    game = game.next_game while game.next_game.present?
    game
  end

  def self.round_for(round_number, region=nil)
    case round_number
      when 5
        [Game.championship.game_one, Game.championship.game_two]
      when 6
        [Game.championship]
      when 1
        sort_order = [1, 8, 5, 4, 6, 3, 7, 2]
        Team.where(:region => region).all.collect(&:first_game).uniq.sort_by {|x| sort_order.index(x.first_team.seed)}
      else
        Game.round_for(round_number - 1, region).collect(&:next_game).uniq
    end
  end
end
