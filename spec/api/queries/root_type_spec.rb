require "rails_helper"

RSpec.describe Queries::RootType do
  subject { Queries::RootType }

  context "fields" do
    let(:fields) { %w(node lists pool current_user) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end

  context "current_user" do
    subject { Queries::RootType.fields["current_user"] }

    context "signed in" do
      let(:user) { create(:user) }

      it "is the signed in user" do
        expect(subject.resolve(nil, nil, current_user: user, current_ability: Ability.new(user))).to eq(user)
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

  context "pool" do
    subject { Queries::RootType.fields["pool"] }
    let!(:user) { create :user }
    let(:ability) { Ability.new(user) }
    let!(:pool_users) { create_list :pool_user, 3, user: user }
    let(:pools) { user.reload.pools }
    let(:pool) { pools.shuffle.pop }
    let(:args) { { "model_id" => pool.id } }

    context "signed in" do
      context "as a user with Pool access" do
        it "is the pool" do
          expect(subject.resolve(nil, args, current_user: user, current_ability: ability)).to eq(pool)
        end
      end

      context "as a user without access" do
        let(:another_user) { create(:user) }
        let(:another_ability) { Ability.new(another_user) }

        it "is an error" do
          expect do
            subject.resolve(nil, args, current_user: another_user, current_ability: another_ability)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "not signed in" do
      it "is a graphql execution error" do
        result = subject.resolve(nil, args, {})
        expect(result).to be_a(GraphQL::ExecutionError)
        expect(result.message).to match(/must be signed in/i)
      end
    end
  end
end
