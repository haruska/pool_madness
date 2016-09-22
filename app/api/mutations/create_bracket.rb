module Mutations
  CreateBracket = GraphQL::Relay::Mutation.define do
    name "CreateBracket"

    input_field :pool_id, !types.ID

    return_field :bracket_edge, Queries::BracketType.edge_type
    return_field :pool, Queries::PoolType

    resolve lambda { |inputs, context|
      user = context[:current_user]
      ability = context[:current_ability]

      raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

      pool = Queries::NodeInterface.object_from_id(inputs[:pool_id], {})
      bracket = pool.brackets.build(user: user)

      if ability.can?(:create, bracket)
        bracket.save!
      else
        raise GraphQL::ExecutionError, "You cannot create a bracket in this pool"
      end

      connection_class = GraphQL::Relay::BaseConnection.connection_for_nodes(pool.brackets.accessible_by(ability))
      connection = connection_class.new(pool.brackets.accessible_by(ability), {})

      {
        bracket_edge: GraphQL::Relay::Edge.new(bracket, connection),
        pool: pool
      }
    }
  end
end
