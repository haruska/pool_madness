module Queries
  TeamType = GraphQL::ObjectType.define do
    name "Team"
    description "A team"
    interfaces [NodeInterface.interface]
    global_id_field :id

    field :model_id, !types.Int
    field :seed, !types.Int
    field :name, !types.String
    field :still_playing, !types.Boolean, property: :still_playing?
  end
end
