require "rails_helper"

RSpec.describe Queries::RootType do
  subject { described_class }

  context "fields" do
    let(:fields) { %w(node nodes viewer lists pool bracket) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end

  context "viewer" do
    subject { described_class.fields["viewer"] }

    it "is the viewer singleton" do
      expect(subject.resolve(nil, nil, {}).id).to eq(Viewer::ID)
    end
  end

  context "pool" do
    subject { described_class.fields["pool"] }
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

  context "bracket" do
    subject { described_class.fields["bracket"] }
    let(:bracket) { create(:bracket) }
    let(:user) { bracket.user }
    let(:ability) { Ability.new(user) }
    let(:args) { { "model_id" => bracket.id } }

    context "signed in" do
      context "as the bracket owner" do
        it "is the bracket" do
          expect(subject.resolve(nil, args, current_user: user, current_ability: ability)).to eq(bracket)
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
