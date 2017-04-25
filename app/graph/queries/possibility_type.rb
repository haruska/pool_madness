module Queries
  PossibilityType = GraphQL::ObjectType.define do
    name "Possibility"
    description "A possible result of a pool"

    field :championships, types[PossibleGameType]
    field :first_place, types[BracketType] do
      resolve ->(possibility, _args, _context) { possibility.best_brackets.first }
    end
    field :second_place, types[BracketType] do
      resolve ->(possibility, _args, _context) { possibility.best_brackets.second }
    end
    field :third_place, types[BracketType] do
      resolve ->(possibility, _args, _context) { possibility.best_brackets.third }
    end
  end
end
