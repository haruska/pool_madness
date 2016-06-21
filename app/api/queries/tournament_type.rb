module Queries
  TournamentType = GraphQL::ObjectType.define do
    name "Tournament"
    description "Single elimination bracket tournament"
    interfaces [NodeInterface.interface]

    global_id_field :id
    field :name, !types.String
    field :num_rounds, !types.Int
    field :archived, !types.Boolean, property: :archived?
    field :games_remaining, !types.Int, property: :num_games_remaining
    field :tip_off, !types.String do
      resolve -> (tournament, _args, _context) { tournament.tip_off.as_json }
    end
  end
end
