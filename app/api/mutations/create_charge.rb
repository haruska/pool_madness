module Mutations
  CreateCharge = GraphQL::Relay::Mutation.define do
    name "CreateCharge"
    description "Create a credit card charge for a group of brackets"

    input_field :pool_id, !types.ID
    input_field :token, !types.String

    return_field :charge, Queries::ChargeType
    return_field :pool, Queries::PoolType

    resolve lambda { |inputs, context|
      pool = Queries::NodeInterface.object_from_id(inputs[:pool_id], context)

      raise ActiveRecord::RecordNotFound unless context[:current_ability].can?(:read, pool)

      user = context[:current_user]
      brackets = pool.brackets.where(user_id: user.id).to_a.select { |b| b.status == :unpaid }
      amount = brackets.size * pool.entry_fee

      charge = Stripe::Charge.create(
        amount: amount,
        currency: "usd",
        source: inputs[:token],
        description: "#{brackets.size} bracket(s) in the pool #{pool.name} at PoolMadness",
        statement_descriptor: "PoolMadness Brackets",
        metadata: { bracket_ids: brackets.map(&:id).to_s, email: user.email }
      )

      brackets.each(&:paid!)

      { charge: charge, pool: pool }
    }
  end
end
