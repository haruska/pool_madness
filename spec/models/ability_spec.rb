require "spec_helper"
require "cancan/matchers"

describe Ability, type: :model do
  before(:all) { @pool = create(:pool) }
  let(:pool) { @pool }

  context "not logged in" do
    let(:user) { User.new }
    subject { Ability.new(user) }

    it { should_not be_able_to(:read, User) }
    it { should_not be_able_to(:read, Bracket) }
    it { should_not be_able_to(:read, Pick) }
    it { should_not be_able_to(:read, Game) }
    it { should_not be_able_to(:read, Tournament) }
  end

  context "logged in" do
    let(:user) { create(:user) }
    let!(:pool_user) { create(:pool_user, user: user, pool: pool) }
    let(:bracket) { create(:bracket, pool: pool, user: user) }
    let(:another_bracket) { create(:bracket, pool: pool) }

    context "as a regular user" do
      subject { Ability.new(user) }

      it { should be_able_to(:manage, user) }
      it { should_not be_able_to(:read, create(:user)) }

      it { should be_able_to(:read, Tournament) }
      it { should_not be_able_to(:create, Tournament) }

      it { should be_able_to(:read, Game) }
      it { should_not be_able_to(:update, Game.first) }

      it { should be_able_to(:read, pool) }
      it { should_not be_able_to(:manage, pool) }

      context "pool has started" do
        before { pool.tournament.update(tip_off: 1.day.ago) }

        subject { Ability.new(user) }

        it { should be_able_to(:read, bracket) }
        it { should be_able_to(:read, another_bracket) }

        it { should_not be_able_to(:manage, bracket) }
        it { should_not be_able_to(:create, pool.brackets.build(user: user)) }
        it { should_not be_able_to(:destroy, bracket) }
        it { should_not be_able_to(:update, bracket) }

        it { should_not be_able_to(:update, bracket.picks.sample) }
        it { should_not be_able_to(:read, another_bracket.picks.sample) }
      end

      context "pool has not started" do
        before { pool.tournament.update(tip_off: 1.day.from_now) }

        subject { Ability.new(user) }

        it { should be_able_to(:manage, bracket) }
        it { should_not be_able_to(:read, another_bracket) }

        it { should be_able_to(:update, bracket.picks.sample) }
        it { should_not be_able_to(:update, another_bracket.picks.sample) }
      end
    end

    context "as a pool admin" do
      let(:another_pool_bracket) { create(:bracket) }

      before { pool_user.admin! }

      subject { Ability.new(user) }

      it { should be_able_to(:manage, pool) }

      context "the pool has started" do
        before { pool.tournament.update(tip_off: 1.day.ago) }

        subject { Ability.new(user) }

        it { should be_able_to(:destroy, bracket) }
        it { should be_able_to(:destroy, another_bracket) }
        it { should_not be_able_to(:edit, bracket) }
        it { should_not be_able_to(:edit, another_bracket) }
        it { should_not be_able_to(:destroy, another_pool_bracket) }
      end

      context "the pool has not started" do
        before { pool.tournament.update(tip_off: 1.day.from_now) }

        subject { Ability.new(user) }

        it { should be_able_to(:manage, bracket) }
        it { should be_able_to(:manage, another_bracket) }
        it { should_not be_able_to(:manage, another_pool_bracket) }

        it { should be_able_to(:update, bracket.picks.first) }
        it { should be_able_to(:update, another_bracket.picks.first) }
        it { should_not be_able_to(:update, another_pool_bracket.picks.first) }
      end
    end

    context "as an admin user" do
      let(:user) { create(:admin_user) }
      subject { Ability.new(user) }

      it { should be_able_to(:manage, :all) }
    end
  end
end
