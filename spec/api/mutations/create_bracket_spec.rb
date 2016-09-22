require "rails_helper"

RSpec.describe Mutations::CreateBracket do
  subject { Mutations::CreateBracket.field }
  let(:user) { create(:user) }
  let(:graphql_args) { GraphQL::Query::Arguments.new(input: args.merge(clientMutationId: "0")) }
  let(:graphql_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graphql_result) { subject.resolve(nil, graphql_args, graphql_context) }

  context "not logged in" do
    let(:user) { nil }
    let(:args) { {} }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You must be signed in to update this information")
    end
  end

  context "logged in" do
    let(:pool) { create(:pool) }
    let(:pool_graph_id) { GraphQL::Relay::GlobalNodeIdentification.new.to_global_id("Pool", pool.id) }
    let(:args) { { pool_id: pool_graph_id } }

    context "user is not a member of the pool" do
      it "raises an auth error" do
        expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You cannot create a bracket in this pool")
      end
    end

    context "user is a member of the pool" do
      let!(:pool_user) { create(:pool_user, pool: pool, user: user) }

      context "and the pool has not started" do
        before do
          pool.tournament.update(tip_off: 1.day.from_now)
          expect(pool).to_not be_started
        end

        it "creates a new bracket in the pool for the user" do
          expect { graphql_result }.to change(pool.reload.brackets, :count).by(1)
          expect(user.brackets.first.pool).to eq(pool)
        end
      end

      context "and the pool has already started" do
        it "raises an auth error" do
          expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You cannot create a bracket in this pool")
        end
      end
    end
  end
end
