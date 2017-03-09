require "rails_helper"

RSpec.describe Mutations::DeleteBracket do
  subject { Mutations::DELETE_BRACKET_LAMBDA }
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
    let(:bracket) { create(:bracket) }
    let(:bracket_graph_id) { GraphqlSchema.id_from_object(bracket, nil, nil) }
    let(:args) { { bracket_id: bracket_graph_id } }

    context "user who cannot destroy the bracket" do
      it "raises an auth error" do
        expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You cannot delete this bracket")
      end
    end

    context "user is bracket owner" do
      let(:user) { bracket.user }
      let(:pool) { bracket.pool }

      context "and the pool has not started" do
        before do
          pool.tournament.update(tip_off: 1.day.from_now)
          expect(pool).to_not be_started
        end

        it "destroys the bracket" do
          expect { graphql_result }.to change(pool.reload.brackets, :count).by(-1)
          expect { bracket.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "and the pool has already started" do
        it "raises an auth error" do
          expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You cannot delete this bracket")
        end
      end
    end
  end
end
