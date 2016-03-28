class PossibleOutcome
  include ActiveAttr::Model

  attribute :possible_outcome_set
  attribute :game_decisions
  attribute :tree_attr

  delegate :tournament, :all_games_mask, :pool_brackets_cache, :bracket_trees_cache, to: :possible_outcome_set

  def tree
    self.tree_attr ||= TournamentTree.unmarshal(tournament, game_decisions, all_games_mask)
  end

  def sorted_brackets(pool)
    result = pool_brackets_cache(pool).map do |bracket|
      bracket_tree = bracket_trees_cache(bracket)
      points = (1..tournament.num_games).map { |slot| bracket_tree.at(slot).points(tree.at(slot)) }.sum
      [bracket, points]
    end

    result.sort_by(&:last).reverse
  end

  def best_possible_by_rank(pool)
    get_best_possible(pool).each_with_object([]) do |(bracket, rank), rb|
      rb[rank] ||= []
      rb[rank] << bracket
    end
  end

  def get_best_possible(pool)
    s_brackets = sorted_brackets(pool)

    third_place_index = 2
    third_place_points = s_brackets[third_place_index][1]
    while s_brackets[third_place_index + 1][1] == third_place_points
      third_place_index += 1
    end

    s_brackets[0..third_place_index].map do |bracket, points|
      index = s_brackets.index { |_b, p| p == points }
      [bracket, index]
    end
  end
end
