module Queries
  UserType = GraphQL::ObjectType.define do
    name "User"
    description "User's details"

    interfaces [NodeInterface.interface]
    global_id_field :id

    field :model_id, !types.Int, property: :id
    field :email, !types.String
    field :name, !types.String
  end
end
