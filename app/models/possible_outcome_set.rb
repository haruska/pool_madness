class PossibleOutcomeSet
  include ActiveAttr::Model

  attribute :tournament
  attribute :teams_attr

  attribute :games_attr
  attribute :already_played_games_attr
  attribute :not_played_games_attr

  attribute :round_for_cache_attr
  attribute :pool_brackets_cache_attr
  attribute :bracket_picks_cache_attr

  attribute :possible_outcome_attr

  def already_played_games
    self.already_played_games_attr ||= tournament.games.already_played.to_a
  end

  def not_played_games
    self.not_played_games_attr ||= tournament.games.not_played.to_a
  end

  def teams
    self.teams_attr ||= tournament.teams.each_with_object(Hash.new) {|team, acc| acc[team.id] = team}
  end

  def games
    self.games_attr ||= already_played_games + not_played_games
  end

  def min_slot_bits
    already_played_winners_mask = 0

    already_played_games.each_with_index do |game, i|
      slot_index = already_played_games.size - i - 1
      if game.score_one < game.score_two
        already_played_winners_mask |= 1 << slot_index
      end
    end

    already_played_winners_mask << not_played_games.size
  end

  def max_slot_bits
    to_play_games_mask = 2**not_played_games.size - 1
    min_slot_bits | to_play_games_mask
  end

  def possible_outcome
    if possible_outcome_attr.nil?
      self.possible_outcome_attr = PossibleOutcome.new(possible_outcome_set: self)
    end
    possible_outcome_attr
  end

  def update_outcome(slot_bits)
    games.each_with_index do |game, i|
      slot_index = games.size - i - 1
      team_one_winner = slot_bits & (1 << slot_index) == 0
      score_one, score_two = team_one_winner ?  [2, 1] : [1, 2]
      possible_outcome.create_or_update_possible_game game: game, score_one: score_one, score_two: score_two
    end

    possible_outcome
  end

  def round_for_cache(round_number, region)
    self.round_for_cache_attr ||= {}
    if round_for_cache_attr[[round_number, region]].nil?
      round_for_cache_attr[[round_number, region]] = tournament.round_for(round_number, region)
    end
    round_for_cache_attr[[round_number, region]]
  end

  def pool_brackets_cache(pool)
    self.pool_brackets_cache_attr ||= {}
    if pool_brackets_cache_attr[pool.id].nil?
      pool_brackets_cache_attr[pool.id] = pool.brackets.to_a
    end
    pool_brackets_cache_attr[pool.id]
  end

  def bracket_picks_cache(bracket)
    self.bracket_picks_cache_attr ||= {}
    if bracket_picks_cache_attr[bracket.id].nil?
      bracket_picks_cache_attr[bracket.id] = bracket.picks.to_a
    end
    bracket_picks_cache_attr[bracket.id]
  end
end
