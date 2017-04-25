GraphqlSchema = GraphQL::Schema.define do
  query ::Types::RootType
  mutation ::Mutations::RootMutation

  id_from_object lambda { |object, _type_definition, _query_ctx|
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
  }

  object_from_id lambda { |id, _query_ctx|
    class_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
    Object.const_get(class_name).find(item_id)
  }

  resolve_type lambda { |object, _context|
    class_name = object.class.name
    "Types::#{class_name}Type".constantize
  }
end

GraphqlSchema.rescue_from(ActiveRecord::RecordInvalid) do |error|
  error.record.errors.each_with_object({}) { |(attr, msg), obj| obj[attr.to_s] = Array(msg).uniq }.to_json
end
