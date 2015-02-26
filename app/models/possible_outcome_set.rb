class PossibleOutcomeSet
  include ActiveAttr::Model

  attribute :pool

  attribute :brackets_attr
  attribute :teams_attr

  attribute :already_played_games_attr
  attribute :not_played_games_attr

  delegate :tournament, to: :pool

  def already_played_games
    self.already_played_games_attr ||= tournament.games.already_played.to_a
  end

  def not_played_games
    self.not_played_games_attr ||= tournament.games.not_played.to_a
  end

  def brackets
    self.brackets_attr ||= pool.brackets.includes(:picks).to_a
  end

  def teams
    self.teams_attr ||= tournament.teams.each_with_object(Hash.new) {|team, acc| acc[team.id] = team}
  end

  def games
    already_played_games + not_played_games
  end

  def all_slot_bits
    already_played_winners_mask = 0

    already_played_games.each_with_index do |game, i|
      slot_index = already_played_games.size - i - 1
      if game.score_one < game.score_two
        already_played_winners_mask |= 1 << slot_index
      end
    end

    to_play_games_mask = 1
    not_played_games.size.times { |i| to_play_games_mask |= 1 << i }

    collected_slot_bits = []
    (0..to_play_games_mask).each do |to_play_bits|
      slot_bits = (already_played_winners_mask << not_played_games.size) | to_play_bits
      block_given? ? yield(slot_bits) : collected_slot_bits << slot_bits
    end

    block_given? ? nil : collected_slot_bits
  end

  def generate_outcome(slot_bits)
    possible_outcome = PossibleOutcome.new(possible_outcome_set: self, slot_bits: slot_bits)

    games.each_with_index do |game, i|
      slot_index = games.size - i - 1
      team_one_winner = slot_bits & (1 << slot_index) == 0
      score_one, score_two = team_one_winner ?  [2, 1] : [1, 2]
      possible_outcome.create_possible_game game: game, score_one: score_one, score_two: score_two
    end

    possible_outcome
  end
end
