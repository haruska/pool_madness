module Queries
  PoolType = GraphQL::ObjectType.define do
    name "Pool"
    description "A bracket pool for a tournament"

    interfaces [NodeInterface.interface]
    global_id_field :id

    field :model_id, !types.Int do
      resolve -> (object, _args, _context) { object.id }
    end

    field :tournament, !TournamentType
    field :name, !types.String
    field :invite_code, !types.String
  end
end
