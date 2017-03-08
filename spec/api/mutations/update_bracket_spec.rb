require "rails_helper"

RSpec.describe Mutations::UpdateBracket do
  subject { Mutations::UpdateBracket.field }

  let(:tournament) { create(:tournament, :not_started) }
  let(:pool) { create(:pool, tournament: tournament) }
  let(:bracket) { create(:bracket, pool: pool) }
  let(:bracket_graph_id) { GraphQL::Relay::GlobalNodeIdentification.new.to_global_id("Bracket", bracket.id) }
  let(:user) { bracket.user }

  let(:graphql_args) { GraphQL::Query::Arguments.new(input: args.merge(clientMutationId: "0")) }
  let(:graphql_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graphql_result) { subject.resolve(nil, graphql_args, graphql_context) }

  let(:completed_bracket) { create(:bracket, :completed, pool: pool) }
  let(:name) { Faker::Lorem.words(2).join(" ") }
  let(:tie_breaker) { Faker::Number.between(50, 120) }
  let(:game_decisions) { Array.new(2**bracket.tournament.num_rounds) { |i| (completed_bracket.tree_decisions & (1 << i)).zero? ? "0" : "1" }.join("") }
  let(:game_mask) { Array.new(2**bracket.tournament.num_rounds) { |i| (completed_bracket.tree_mask & (1 << i)).zero? ? "0" : "1" }.join("") }

  let(:args) do
    {
      bracket_id: bracket_graph_id,
      name: name,
      tie_breaker: tie_breaker,
      game_decisions: game_decisions,
      game_mask: game_mask
    }
  end

  context "with valid data" do
    before do
      graphql_result
      bracket.reload
    end

    it "updates the bracket" do
      expect(bracket.name).to eq(name)
      expect(bracket.tie_breaker).to eq(tie_breaker)
      expect(bracket.tree_decisions).to eq(completed_bracket.tree_decisions)
      expect(bracket.tree_mask).to eq(completed_bracket.tree_mask)
    end

    it "includes the updated bracket in the result" do
      expect(graphql_result.result[:bracket]).to eq(bracket)
    end
  end

  context "with invalid data" do
    let!(:original_name) { bracket.name }
    let(:name) { completed_bracket.name }

    before do
      expect { graphql_result }.to raise_error(ActiveRecord::RecordInvalid)
      bracket.reload
    end

    it "does not update the bracket" do
      expect(bracket.name).to eq(original_name)
    end
  end

  context "not logged in" do
    let(:user) { nil }
    let(:args) { {} }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You must be signed in to update this information")
    end
  end

  context "user who cannot update the bracket" do
    let(:user) { completed_bracket.user }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You cannot update this bracket")
    end
  end
end
