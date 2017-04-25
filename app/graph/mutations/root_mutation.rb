module Mutations
  RootMutation = GraphQL::ObjectType.define do
    name "RootMutation"
    description "The mutation root of this schema"

    field :create_charge, field: CreateCharge.field
    field :accept_invitation, field: AcceptInvitation.field
    field :update_profile, field: UpdateProfile.field
    field :create_bracket, field: CreateBracket.field
    field :update_bracket, field: UpdateBracket.field
    field :delete_bracket, field: DeleteBracket.field
  end
end
