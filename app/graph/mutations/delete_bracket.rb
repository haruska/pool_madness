module Mutations
  DELETE_BRACKET_LAMBDA = lambda do |_object, inputs, context|
    user = context[:current_user]
    ability = context[:current_ability]

    raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

    bracket = GraphqlSchema.object_from_id(inputs["bracket_id"], {})
    pool = bracket.pool

    if ability.can?(:destroy, bracket)
      bracket.destroy
    else
      raise GraphQL::ExecutionError, "You cannot delete this bracket"
    end

    {
      deleted_bracket_id: inputs["bracket_id"],
      pool: pool
    }
  end

  DeleteBracket = GraphQL::Relay::Mutation.define do
    name "DeleteBracket"

    input_field :bracket_id, !types.ID

    return_field :deleted_bracket_id, !types.ID
    return_field :pool, Types::PoolType

    resolve DELETE_BRACKET_LAMBDA
  end
end
