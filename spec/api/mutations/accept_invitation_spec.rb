require "rails_helper"

RSpec.describe Mutations::AcceptInvitation do
  subject { Mutations::AcceptInvitation.field }
  let(:user) { create(:user) }
  let(:pool) { create(:pool) }
  let(:graphql_args) { GraphQL::Query::Arguments.new(input: args.merge(clientMutationId: "0")) }
  let(:graphql_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graphql_result) { subject.resolve(nil, graphql_args, graphql_context) }

  context "with a valid code" do
    let(:args) { { invite_code: pool.invite_code } }

    context "and the user is not already in the pool" do
      it "adds the current user to the associated pool" do
        graphql_result
        expect(pool.reload.users).to include(user)
      end

      it "includes the pool in result" do
        expect(graphql_result.result[:pool]).to eq(pool)
      end
    end

    context "and the user is already in the pool" do
      let!(:pool_user) { create(:pool_user, pool: pool, user: user) }

      it "doesn't change the user pool association" do
        expect(pool.reload.users).to include(user)
        graphql_result
        expect(pool.reload.users).to include(user)
      end

      it "includes the pool in result" do
        expect(graphql_result.result[:pool]).to eq(pool)
      end
    end
  end

  context "with an invalid code" do
    let(:args) { { invite_code: "invalidcode" } }

    it "raises a graph error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "Invalid invite code")
    end
  end

  context "not logged in" do
    let(:user) { nil }
    let(:args) { { invite_code: pool.invite_code } }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You must be signed in to view this information")
    end
  end
end
