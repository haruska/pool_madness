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
  end
end
