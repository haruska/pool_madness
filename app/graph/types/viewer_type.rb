module Types
  ViewerType = GraphQL::ObjectType.define do
    name "Viewer"
    description "The top level view of the graph"

    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id

    field :current_user do
      type CurrentUserType
      resolve ->(_v, _a, context) { context[:current_user] }
    end

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
