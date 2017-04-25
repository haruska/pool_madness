module Types
  TeamType = GraphQL::ObjectType.define do
    name "Team"
    description "A team"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id

    field :model_id, !types.Int
    field :seed, !types.Int
    field :name, !types.String
    field :starting_slot, !types.Int
  end
end
