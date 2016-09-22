GraphqlSchema = GraphQL::Schema.define(mutation: Mutations::RootType, query: Queries::RootType)

GraphqlSchema.rescue_from(ActiveRecord::RecordInvalid) do |error|
  error.record.errors.each_with_object({}) { |(attr, msg), obj| obj[attr.to_s] = Array(msg).uniq }.to_json
end
