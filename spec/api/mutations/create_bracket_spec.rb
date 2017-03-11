require "rails_helper"

RSpec.describe Mutations::CreateBracket do
  subject { Mutations::CREATE_BRACKET_LAMBDA }
  let(:user) { create(:user) }
  let(:graphql_args) { args.deep_stringify_keys }
  let(:graphql_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graphql_result) { subject.call(nil, graphql_args, graphql_context) }

  context "not logged in" do
    let(:user) { nil }
    let(:args) { {} }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You must be signed in to update this information")
    end
  end

  context "logged in" do
    let(:pool) { create(:pool) }
    let(:pool_graph_id) { GraphqlSchema.id_from_object(pool, nil, nil) }
    let!(:completed_bracket) { create(:bracket, :completed, pool: pool) }
    let(:name) { Faker::Lorem.words(2).join(" ") }
    let(:tie_breaker) { Faker::Number.between(50, 120) }
    let(:game_decisions) { Array.new(2**pool.tournament.num_rounds) { |i| (completed_bracket.tree_decisions & (1 << i)).zero? ? "0" : "1" }.join("") }
    let(:game_mask) { Array.new(2**pool.tournament.num_rounds) { |i| (completed_bracket.tree_mask & (1 << i)).zero? ? "0" : "1" }.join("") }

    let(:args) do
      {
        pool_id: pool_graph_id,
        name: name,
        tie_breaker: tie_breaker,
        game_decisions: game_decisions,
        game_mask: game_mask
      }
    end

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
