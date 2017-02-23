module Mutations
  DeleteBracket = GraphQL::Relay::Mutation.define do
    name "DeleteBracket"

    input_field :bracket_id, !types.ID

    return_field :deleted_bracket_id, !types.ID
    return_field :pool, Queries::PoolType

    resolve lambda { |inputs, context|
      user = context[:current_user]
      ability = context[:current_ability]

      raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

      bracket = Queries::NodeInterface.object_from_id(inputs[:bracket_id], {})
      pool = bracket.pool

      if ability.can?(:destroy, bracket)
        bracket.destroy
      else
        raise GraphQL::ExecutionError, "You cannot delete this bracket"
      end

      {
        deleted_bracket_id: inputs[:bracket_id],
        pool: pool
      }
    }
  end
end
