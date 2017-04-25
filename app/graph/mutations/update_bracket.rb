module Mutations
  UPDATE_BRACKET_LAMBDA = lambda do |_object, inputs, context|
    user = context[:current_user]
    ability = context[:current_ability]

    raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

    bracket = GraphqlSchema.object_from_id(inputs["bracket_id"], {})

    raise GraphQL::ExecutionError, "You cannot update this bracket" unless ability.can?(:edit, bracket)

    game_decisions = inputs["game_decisions"] ? bitstring_to_int(inputs["game_decisions"]) : bracket.game_decisions
    game_mask = inputs["game_mask"] ? bitstring_to_int(inputs["game_mask"]) : bracket.game_mask
    bracket.update(
      {
        name: inputs["name"],
        tie_breaker: inputs["tie_breaker"],
        tree_decisions: game_decisions,
        tree_mask: game_mask
      }.compact
    )

    if bracket.valid?
      { bracket: bracket }
    else
      { errors: bracket.errors.messages }
    end
  end

  UpdateBracket = GraphQL::Relay::Mutation.define do
    name "UpdateBracket"
    description "Update a bracket entry"

    input_field :bracket_id, !types.ID
    input_field :name, types.String
    input_field :tie_breaker, types.Int
    input_field :game_decisions, types.String
    input_field :game_mask, types.String

    return_field :bracket, Types::BracketType
    return_field :errors, ValidationErrorList

    resolve UPDATE_BRACKET_LAMBDA
  end
end
