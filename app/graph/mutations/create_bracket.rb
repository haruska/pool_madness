module Mutations
  CREATE_BRACKET_LAMBDA = lambda { |_object, inputs, context|
    user = context[:current_user]
    ability = context[:current_ability]

    raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

    pool = GraphqlSchema.object_from_id(inputs["pool_id"], {})

    raise GraphQL::ExecutionError, "You cannot create a bracket in this pool" unless ability.can?(:create, pool.brackets.build(user: user))

    bracket = pool.brackets.create(
      {
        user: user,
        name: inputs["name"],
        tie_breaker: inputs["tie_breaker"],
        tree_decisions: bitstring_to_int(inputs["game_decisions"]),
        tree_mask: bitstring_to_int(inputs["game_mask"])
      }.compact
    )

    connection_class = GraphQL::Relay::BaseConnection.connection_for_nodes(pool.brackets.accessible_by(ability))
    connection = connection_class.new(pool.brackets.accessible_by(ability), {})

    if bracket.valid?
      { bracket_edge: GraphQL::Relay::Edge.new(bracket, connection), pool: pool }
    else
      { errors: bracket.errors.messages, pool: pool }
    end
  }

  CreateBracket = GraphQL::Relay::Mutation.define do
    name "CreateBracket"

    input_field :pool_id, !types.ID
    input_field :name, !types.String
    input_field :tie_breaker, !types.Int
    input_field :game_decisions, !types.String
    input_field :game_mask, !types.String

    return_field :bracket_edge, Queries::BracketType.edge_type
    return_field :pool, Queries::PoolType
    return_field :errors, ValidationErrorList

    resolve CREATE_BRACKET_LAMBDA
  end
end
