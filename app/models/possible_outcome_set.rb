class PossibleOutcomeSet
  include ActiveAttr::Model

  attribute :tournament

  attribute :teams_attr
  attribute :tournament_tree_attr
  attribute :pool_brackets_cache_attr
  attribute :bracket_trees_cache_attr
  attribute :all_games_mask_attr

  def teams
    self.teams_attr ||= tournament.teams.each_with_object({}) { |team, acc| acc[team.id] = team }
  end

  def tournament_tree
    self.tournament_tree_attr ||= tournament.tree
  end

  def all_games_mask
    self.all_games_mask_attr ||= tournament_tree.all_games_mask
  end

  def fixed_slot_mask
    to_slot_bits(tournament.game_mask)
  end

  def fixed_slot_bits
    to_slot_bits(tournament.game_decisions)
  end

  def to_play_games_mask
    2**tournament.num_games_remaining - 1
  end

  def slot_bits_for(variable_bits)
    slot_bits = fixed_slot_bits
    tournament.num_games.times do |i|
      slot = 1 << i
      if fixed_slot_mask & slot == 0 #if not already played
        bit = variable_bits & 1
        variable_bits = variable_bits >> 1

        slot_bits = slot_bits | (bit << i)
      end
    end
    slot_bits
  end

  def outcome_for(slot_bits)
    PossibleOutcome.new possible_outcome_set: self, game_decisions: to_game_decisions(slot_bits)
  end

  def pool_brackets_cache(pool)
    self.pool_brackets_cache_attr ||= {}
    if pool_brackets_cache_attr[pool.id].nil?
      pool_brackets_cache_attr[pool.id] = pool.brackets.to_a
    end
    pool_brackets_cache_attr[pool.id]
  end

  def bracket_trees_cache(bracket)
    self.bracket_trees_cache_attr ||= {}
    bracket_trees_cache_attr[bracket.id] ||= bracket.tree
    bracket_trees_cache_attr[bracket.id]
  end

  private

  def to_slot_bits(game_decisions)
    game_decisions >> 1
  end

  def to_game_decisions(slot_bits)
    slot_bits << 1
  end
end
