module Queries
  BracketType = GraphQL::ObjectType.define do
    name "Bracket"
    description "A bracket"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id

    field :model_id, !types.ID, property: :id
    field :name, !types.String
    field :owner, !UserType, property: :user
    field :editable, !types.Boolean do
      resolve ->(bracket, _args, context) { context[:current_ability].can?(:edit, bracket) }
    end
    field :tie_breaker, types.Int
    field :status, !types.String
    field :points, !types.Int
    field :possible_points, !types.Int
    field :final_four, types[TeamType], property: :sorted_four

    field :best_possible_finish, !types.String do
      resolve ->(bracket, _args, _context) { bracket.best_possible < 3 ? (bracket.best_possible + 1).ordinalize : "-" }
    end

    field :eliminated, !types.Boolean do
      resolve ->(bracket, _args, _context) { bracket.best_possible > 2 }
    end

    field :pool, !PoolType

    field :game_decisions, !types.String do
      resolve -> (bracket, _args, _context) { Array.new(2**bracket.tournament.num_rounds) { |i| (bracket.tree_decisions & (1 << i)).zero? ? "0" : "1" }.join("") }
    end

    field :game_mask, !types.String do
      resolve -> (bracket, _args, _context) { Array.new(2**bracket.tournament.num_rounds) { |i| (bracket.tree_mask & (1 << i)).zero? ? "0" : "1" }.join("") }
    end
  end
end
