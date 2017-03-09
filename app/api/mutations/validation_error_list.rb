module Mutations
  ValidationErrorList = GraphQL::ListType.new(of_type: ValidationError)
end
