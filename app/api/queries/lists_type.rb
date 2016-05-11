module Queries
  ListsType = GraphQL::ObjectType.define do
    name "Lists"
    description "Top level lists"

    field :pools, !PoolsType do
      description "All pools associated with current user"
      resolve lambda { |_object, _args, context|
        Pool.current.accessible_by(context[:current_ability])
      }
    end
  end
end
