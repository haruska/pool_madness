module Queries
  RoundType = GraphQL::ObjectType.define do
    name "Round"
    description "A round of games in a tournament"

    interfaces [NodeInterface.interface]
    global_id_field :id

    field :name, !types.String
    field :number, !types.Int
    field :start_date, !types.String do
      resolve -> (round, _args, _context) { round.start_date.to_date.iso8601 }
    end
    field :end_date, !types.String do
      resolve -> (round, _args, _context) { round.end_date.to_date.iso8601 }
    end

    field :regions, types[types.String]
  end
end
