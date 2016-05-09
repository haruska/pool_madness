GraphqlSchema = GraphQL::Schema.new(query: Queries::RootType)

GraphqlSchema.rescue_from(ActiveRecord::RecordInvalid) do |error|
  error.record.errors.messages.to_json
end
