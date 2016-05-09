module Queries
  RootType = GraphQL::ObjectType.define do
    name "RootType"
    description "The query root of this schema"

    field :node, field: NodeInterface.field
  end
end
