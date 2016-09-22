require "rails_helper"

RSpec.describe Mutations::UpdateProfile do
  subject { Mutations::UpdateProfile.field }
  let(:user) { create(:user) }
  let(:graphql_args) { GraphQL::Query::Arguments.new(input: args.merge(clientMutationId: "0")) }
  let(:graphql_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graphql_result) { subject.resolve(nil, graphql_args, graphql_context) }

  context "with valid data" do
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    let(:args) { { name: name, email: email } }

    before do
      graphql_result
      user.reload
    end

    it "updates the current user's profile" do
      expect(user.name).to eq(name)
      expect(user.email).to eq(email)
    end

    it "includes the updated user in result" do
      expect(graphql_result.result[:current_user]).to eq(user)
    end
  end

  context "with invalid data" do
    let!(:original_email) { user.email }
    let(:email) { "invalidemail" }
    let(:args) { { email: email } }

    before do
      expect { graphql_result }.to raise_error(ActiveRecord::RecordInvalid)
      user.reload
    end

    it "does not update the profile" do
      expect(user.email).to eq(original_email)
    end
  end

  context "not logged in" do
    let(:user) { nil }
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    let(:args) { { name: name, email: email } }

    it "raises an auth error" do
      expect { graphql_result }.to raise_error(GraphQL::ExecutionError, "You must be signed in to update this information")
    end
  end
end
