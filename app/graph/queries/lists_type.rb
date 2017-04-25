module Queries
  ListsType = GraphQL::ObjectType.define do
    name "Lists"
    description "Top level lists"

    field :pools, !PoolsType do
      description "All pools associated with current user"
      resolve lambda { |_object, _args, context|
        if context[:current_ability]
          Pool.accessible_by(context[:current_ability])
        else
          GraphQL::ExecutionError.new("You must be signed in to view this information")
        end
      }
    end
  end
end
