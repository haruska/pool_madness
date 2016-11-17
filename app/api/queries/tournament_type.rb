module Queries
  TournamentType = GraphQL::ObjectType.define do
    name "Tournament"
    description "Single elimination bracket tournament"
    interfaces [NodeInterface.interface]

    global_id_field :id
    field :name, !types.String
    field :archived, !types.Boolean, property: :archived?
    field :games_remaining, !types.Int, property: :num_games_remaining

    field :tip_off, !types.String do
      resolve -> (tournament, _args, _context) { tournament.tip_off.iso8601 }
    end

    field :rounds, !types[RoundType]
    field :teams, !types[TeamType]

    field :game_decisions, !types.String do
      resolve -> (tournament, _args, _context) { Array.new(2**tournament.num_rounds) { |i| (tournament.game_decisions & (1 << i)).zero? ? "0" : "1" }.join("") }
    end
    field :game_mask, !types.String do
      resolve -> (tournament, _args, _context) { Array.new(2**tournament.num_rounds) { |i| (tournament.game_mask & (1 << i)).zero? ? "0" : "1" }.join("") }
    end
  end
end
