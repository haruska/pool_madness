module Mutations
  ValidationError = GraphQL::ObjectType.define do
    name "ValidationError"

    field :key, types.String do
      resolve ->(error, _args, _context) { error.first.to_s.camelize(:lower) }
    end
    field :messages, !types[types.String], property: :last
  end
end
