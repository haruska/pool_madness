module Mutations
  RootType = GraphQL::ObjectType.define do
    name "RootMutation"
    description "The mutation root of this schema"

    field :create_charge, field: CreateCharge.field
    field :accept_invitation, field: AcceptInvitation.field
  end
end
