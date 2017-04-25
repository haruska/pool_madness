require "rails_helper"

RSpec.describe Types::ViewerType do
  subject { described_class }

  context "fields" do
    let(:fields) { %w[id current_user pools] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end

  context "pools" do
    subject { described_class.fields["pools"] }
    let!(:pools) { create_list(:pool, 3) }

    context "signed in" do
      let(:user) { create(:user) }
      let(:ability) { Ability.new(user) }

      context "as a user with Pools" do
        let!(:another_pool) { create(:pool) }
        let(:archived_tournament) { create(:tournament, :archived) }
        let(:archived_pool) { create(:pool, tournament: archived_tournament) }

        before do
          pools.each { |p| p.users << user }
          archived_pool.users << user
        end

        it "is a list of the user's pools" do
          expect(subject.resolve(nil, nil, current_ability: ability)).to match_array(pools + [archived_pool])
        end

        it "contains previous year's pools" do
          expect(subject.resolve(nil, nil, current_ability: ability)).to include(archived_pool)
        end

        it "does not contain pools the user doesn't belong to" do
          expect(subject.resolve(nil, nil, current_ability: ability)).to_not include(another_pool)
        end
      end

      context "as a user without Pools" do
        it "is an empty list" do
          expect(subject.resolve(nil, nil, current_ability: ability)).to be_empty
        end
      end
    end

    context "not signed in" do
      it "is a graphql execution error" do
        result = subject.resolve(nil, nil, {})
        expect(result).to be_a(GraphQL::ExecutionError)
        expect(result.message).to match(/must be signed in/i)
      end
    end
  end
end
