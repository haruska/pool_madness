require "rails_helper"

RSpec.describe Mutations::UpdateProfile do
  subject { Mutations::UPDATE_PROFILE_LAMBDA }
  let(:user) { create(:user) }
  let(:graphql_args) { args.deep_stringify_keys }
  let(:graphql_context) { { current_user: user, current_ability: Ability.new(user) } }
  let(:graphql_result) { subject.call(nil, graphql_args, graphql_context) }

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
      expect(graphql_result[:viewer].id).to eq(Viewer::ID)
    end
  end

  context "with invalid data" do
    let!(:original_email) { user.email }
    let(:email) { "invalidemail" }
    let(:args) { { email: email } }

    before do
      graphql_result
      user.reload
    end

    it "has the validation errors" do
      expect(graphql_result[:viewer]).to be_nil
      expect(graphql_result[:errors][:email]).to include("is invalid")
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
