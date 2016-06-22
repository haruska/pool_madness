module Queries
  CurrentUserType = GraphQL::ObjectType.define do
    name "CurrentUser"
    description "Current user's details"

    interfaces [NodeInterface.interface]
    global_id_field :id

    field :model_id, !types.Int, property: :id
    field :email, !types.String
    field :name, !types.String
    field :admin, !types.Boolean, property: :admin?
  end
end
