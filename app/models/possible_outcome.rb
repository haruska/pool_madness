class PossibleOutcome < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :possible_games, :dependent => :destroy

  def championship
    possible_game = self.possible_games.first
    possible_game = possible_game.next_game while possible_game.next_game.present?
    possible_game
  end

  def round_for(round_number, region=nil)
    case round_number
      when 5
        [self.championship.game_one, self.championship.game_two]
      when 6
        [self.championship]
      when 1
        sort_order = [1, 8, 5, 4, 6, 3, 7, 2]

        teams = region.present? ? Team.where(:region => region) : Team
        team_ids = teams.where(:seed => sort_order).select(:id).collect(&:id)
        game_ids = Game.where(:team_one_id => team_ids).select(:id).all.collect(&:id)

        self.possible_games.where(:game_id => game_ids).sort_by {|x| sort_order.index(x.first_team.seed)}
      else
        round_for(round_number - 1, region).collect(&:next_game).uniq
    end
  end

  def self.update_all
    PossibleOutcome.destroy_all
    PossibleGame.destroy_all

    Bracket.all.each do |bracket|
      bracket.best_possible = 10000
      bracket.save!
    end

    generate_all_outcomes do |po|
      po.update_brackets_best_possible
    end
  end

  def self.generate_all_outcomes
    games = Game.all

    games_mask = 0
    already_played_mask = 0
    winners = 0

    games.each_with_index do |game, i|
      games_mask |= 1 << i
      if game.score_one.to_i > 0
        already_played_mask |= 1 << i
        if game.score_one < game.score_two
          winners |= 1 << i
        end
      end
    end

    (0..games_mask).each do |slot_bits|
      if slot_bits & already_played_mask == winners
        #valid slot_bits
        if block_given?
          possible_outcome = generate_outcome(slot_bits)
          yield possible_outcome
          possible_outcome.destroy
        else
          generate_outcome(slot_bits)
        end
      end
    end
  end

  def self.generate_outcome(slot_bits)
    possible_outcome = self.create
    Game.all.each_with_index do |game, i|
      team_one_winner = slot_bits & (1 << i) == 0
      score_one, score_two = team_one_winner ?  [2, 1] : [1, 2]
      
      possible_outcome.possible_games.create :game_id => game.id, :score_one => score_one, :score_two => score_two
    end

    possible_outcome.possible_games.each do |possible_game|
      game = possible_game.game
      game_one_id = nil
      game_two_id = nil
      if game.game_one_id.present?
        possible_game.game_one_id = possible_outcome.possible_games.find_by_game_id(game.game_one_id).id
      end
      if game.game_two_id.present?
        possible_game.game_two_id = possible_outcome.possible_games.find_by_game_id(game.game_two_id).id
      end
      possible_game.save!
    end

    possible_outcome
  end

  def update_brackets_best_possible
    sorted_brackets = self.sorted_brackets
    sorted_brackets.each_with_index do |br, i|
      bracket_id, points = *br
      bracket = Bracket.find(bracket_id)
      index = sorted_brackets.index {|x, y| y == points}
      if bracket.best_possible > index
        bracket.best_possible = index
        bracket.save!
      end
    end
  end

  def sorted_brackets
    result = Bracket.all.collect do |bracket|
      points = bracket.picks.collect do |pick|
        pick.points(possible_games.find_by_game_id(pick.game_id))
      end.sum
      [bracket.id, points]
    end

    result.sort_by(&:last).reverse
  end
end
