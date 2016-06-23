module Queries
  BracketType = GraphQL::ObjectType.define do
    name "Bracket"
    description "A bracket"
    interfaces [NodeInterface.interface]
    global_id_field :id

    field :model_id, !types.ID, property: :id
    field :name, !types.String
    field :owner, !UserType, property: :user
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
  end
end
