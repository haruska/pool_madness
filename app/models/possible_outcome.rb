class PossibleOutcome < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :possible_games, :dependent => :destroy

  attr_accessible :slot_bits

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
    generate_all_slot_bits do |slot_bits|
      if block_given?
        possible_outcome = generate_outcome(slot_bits)
        yield possible_outcome
        possible_outcome.destroy
      else
        generate_outcome(slot_bits)
      end
    end
  end

  def self.generate_all_slot_bits
    already_played_games = Game.where('score_one > 0').order(:id).all
    to_play_games = Game.where('id NOT IN (?)', already_played_games.collect(&:id)).order(:id).all

    already_played_winners_mask = 0

    already_played_games.each_with_index do |game, i|
      if game.score_one < game.score_two
        already_played_winners_mask |= 1 << i
      end
    end

    to_play_games_mask = 1
    to_play_games.size.times {|i| to_play_games_mask |= 1 << i}

    collected_slot_bits = []
    (0..to_play_games_mask).each do |to_play_bits|
      slot_bits = (already_played_winners_mask << to_play_games.size) | to_play_bits
      block_given? ? yield(slot_bits) : collected_slot_bits << slot_bits
    end

    block_given? ? nil : collected_slot_bits
  end

  def self.generate_outcome(slot_bits)
    games = Game.where('score_one > 0').order(:id).all
    games += Game.where('id NOT IN (?)', games.collect(&:id)).order(:id).all

    possible_outcome = self.create(:slot_bits => slot_bits)
    games.each_with_index do |game, i|
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

    third_place_index = 2
    third_place_points = sorted_brackets[third_place_index][1]
    while sorted_brackets[third_place_index+1][1] == third_place_points
      third_place_index += 1
    end

    sorted_brackets[0..third_place_index].each_with_index do |br, i|
      bracket, points = *br
      index = sorted_brackets.index {|x, y| y == points}
      if bracket.best_possible > index
        bracket.best_possible = index
        bracket.save!
      end
    end
  end

  def sorted_brackets
    pg_hash = {}
    possible_games.each do |possible_game|
      pg_hash[possible_game.game_id] = possible_game
    end

    result = Bracket.includes(:picks).all.collect do |bracket|
      points = bracket.picks.collect do |pick|
        pg_hash[pick.game_id].points_for_pick(pick.team_id)
      end.sum
      [bracket, points]
    end

    result.sort_by(&:last).reverse
  end
end
