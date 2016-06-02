module Queries
  TeamType = GraphQL::ObjectType.define do
    name "Team"
    description "A team"
    interfaces [NodeInterface.interface]
    global_id_field :id

    field :name, !types.String
  end
end
