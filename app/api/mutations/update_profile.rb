module Mutations
  UpdateProfile = GraphQL::Relay::Mutation.define do
    name "UpdateProfile"
    description "Update the current user's profile"

    input_field :name, types.String
    input_field :email, types.String

    return_field :current_user, Queries::CurrentUserType

    resolve lambda { |inputs, context|
      user = context[:current_user]
      raise GraphQL::ExecutionError, "You must be signed in to update this information" if user.blank?

      user.name = inputs[:name] if inputs[:name].present?
      user.email = inputs[:email] if inputs[:email].present?

      user.save!

      { current_user: user }
    }
  end
end
