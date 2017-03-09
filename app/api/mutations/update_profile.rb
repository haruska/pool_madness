module Mutations
  UPDATE_PROFILE_LAMBDA = lambda do |_object, inputs, context|
    user = context[:current_user]
    raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

    user.update(
      {
        name: inputs["name"],
        email: inputs["email"]
      }.compact
    )

    if user.valid?
      { viewer: Viewer.new }
    else
      { errors: user.errors.messages }
    end
  end

  UpdateProfile = GraphQL::Relay::Mutation.define do
    name "UpdateProfile"
    description "Update the current user's profile"

    input_field :name, types.String
    input_field :email, types.String

    return_field :viewer, Queries::ViewerType
    return_field :errors, ValidationErrorList

    resolve UPDATE_PROFILE_LAMBDA
  end
end
