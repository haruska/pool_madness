module Queries
  NodeInterface = GraphQL::Relay::GlobalNodeIdentification.define do
    # Given a UUID & the query context,
    # return the corresponding application object
    object_from_id lambda { |id, _config|
      type_name, id = NodeInterface.from_global_id(id)
      type_name.constantize.find(id)
    }

    # Given an application object,
    # return a GraphQL ObjectType to expose that object
    type_from_object ->(object) { GraphqlSchema.types[object.class.name] }
  end
end

GraphqlSchema.node_identification = Queries::NodeInterface
