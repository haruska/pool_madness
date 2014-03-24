class PossibleGame
  include ActiveAttr::Model

  attribute :possible_outcome
  attribute :game
  attribute :score_one
  attribute :score_two

  delegate :team_one_id, :team_two_id, :game_one_id, :game_two_id, :to => :game

  def siblings_hash
    self.possible_outcome.possible_games
  end

  def siblings
    siblings_hash.values
  end

  def game_one
    siblings_hash[self.game_one_id]
  end

  def game_two
    siblings_hash[self.game_two_id]
  end

  def first_team
    @first_team ||= self.game.team_one || self.game_one.winner
  end

  def second_team
    @second_team ||= self.game.team_two || self.game_two.winner
  end

  def winner
    @winner ||= score_one > score_two ? first_team : second_team
  end

  def next_game
    siblings.find {|x| [x.game_one_id, x.game_two_id].include?(game.id)}
  end

  def points_for_pick(team_id)
    team_id == winner.id ? Pick::POINTS_PER_ROUND[round] + winner.seed : 0
  end

  #returns 1, 2 or nil
  def next_slot
    [0, next_game.game_one_id, next_game.game_two_id].index(self.id)
  end

  def round
    @round ||= nil

    return @round unless @round.nil?

    @round = 6 #championship
    n = self.next_game
    while n.present?
      @round -= 1
      n = n.next_game
    end

    @round
  end
end