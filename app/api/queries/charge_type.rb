module Queries
  ChargeType = GraphQL::ObjectType.define do
    name "Charge"
    description "A stripe credit card charge"

    interfaces [NodeInterface.interface]
    global_id_field :id

    field :stripe_id, !types.ID, property: :id
    field :amount, !types.Int # in cents
    field :description, types.String
  end
end
