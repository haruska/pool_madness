GraphqlSchema = GraphQL::Schema.define(mutation: Mutations::RootType, query: Queries::RootType)

GraphqlSchema.rescue_from(ActiveRecord::RecordInvalid) do |error|
  error.record.errors.messages.to_json
end
