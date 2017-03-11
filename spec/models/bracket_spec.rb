require "rails_helper"

RSpec.describe Bracket, type: :model do
  before(:all) { @tournament = create(:tournament) }

  let(:tournament) { @tournament }
  let(:pool) { create(:pool, tournament: tournament) }

  subject { create(:bracket, pool: pool) }

  context "validations" do
    subject { build(:bracket, pool: pool) }

    it "has a valid factory" do
      expect(subject).to be_valid
    end

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:payment_collector) }

    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:pool) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:tie_breaker) }

    context "when an object is required" do
      before { subject.save! }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:pool_id) }
    end

    context "before validation" do
      it "resets tie_breaker to nil if it is <= 0" do
        subject.tie_breaker = 0
        expect(subject).to_not be_valid
        expect(subject.tie_breaker).to be_nil
      end

      it "gives the bracket a default name if the name is blank" do
        user = create(:user)
        bracket = build(:bracket, pool: pool, user: user)

        expected_name = bracket.default_name

        bracket.save!

        expect(bracket.name).to eq(expected_name)
      end
    end
  end

  context "payment_state state machine" do
    it "starts with :unpaid" do
      expect(subject).to be_unpaid
    end

    context "unpaid state" do
      context "and a promise_made event is fired" do
        before { subject.promised! }

        it "transitions to :promised state" do
          expect(subject).to be_promised
        end
      end

      context "and a payment_recieved event is fired" do
        before { subject.paid! }

        it "transitions to :paid state" do
          expect(subject).to be_paid
        end
      end
    end

    context "promised state" do
      before { subject.promised! }

      it "is promised?" do
        expect(subject).to be_promised
      end

      context "and a payment_recieved event is fired" do
        before { subject.paid! }

        it "transitions to :paid state" do
          expect(subject).to be_paid
        end
      end
    end

    context "paid state" do
      before { subject.paid! }

      it "is paid?" do
        expect(subject).to be_paid
      end
    end
  end

  context "#status" do
    context "with a complete bracket" do
      subject { create(:bracket, :completed, pool: pool) }

      context "and it is unpaid" do
        it "is :unpaid" do
          expect(subject.status).to eq(:unpaid)
        end
      end

      context "and it is promised" do
        before { subject.promised! }

        it "is :ok" do
          expect(subject.status).to eq(:ok)
        end
      end

      context "and it is paid" do
        before { subject.paid! }

        it "is :ok" do
          expect(subject.status).to eq(:ok)
        end
      end
    end
  end

  context "#only_bracket_for_user?" do
    context "when the user has a single bracket" do
      it "returns true" do
        expect(subject.user.brackets.count).to eq(1)
        expect(subject).to be_only_bracket_for_user
      end
    end

    context "when the user has multiple brackets" do
      let!(:another_bracket) { create(:bracket, pool: pool, user: subject.user) }

      it "returns false" do
        expect(subject).to_not be_only_bracket_for_user
      end
    end
  end

  context "#default_name" do
    it "is the user's name" do
      expect(subject.name).to eq(subject.user.name)
    end

    context "when a bracket with the user's name exists" do
      let(:another_bracket) { build(:bracket, pool: pool, user: subject.user) }

      it "increments an integer and adds it to the end of the name until unique" do
        expect(another_bracket.default_name).to eq("#{subject.user.name} 1")
      end
    end
  end

  context "#complete? / #incomplete?" do
    subject { create(:bracket, :completed, pool: pool) }

    it "is complete when all picks are selected and a tie_breaker is set" do
      expect(subject.tree).to be_complete
      expect(subject.tie_breaker).to be > 0

      expect(subject).to be_complete
    end

    context "when a pick is not made" do
      subject { build(:bracket, tree_mask: 0, pool: pool) }

      it "is incomplete" do
        expect(subject).to be_incomplete
      end
    end

    context "when a tie_breaker is blank" do
      before { subject.tie_breaker = nil }

      it "is incomplete" do
        expect(subject).to be_incomplete
      end
    end
  end

  context "#sorted_four" do
    subject { create(:bracket, :completed, pool: pool) }

    it "is the teams of final four picks of the bracket" do
      team_slots = subject.tree.round_for(tournament.num_rounds - 2).map(&:value)
      expected_teams = team_slots.map { |slot| tournament.teams.find_by(starting_slot: slot) }

      expected_teams.each { |team| expect(subject.sorted_four).to include(team) }
    end

    it "is reverse-ordered with champ and 2nd place at the end" do
      champ_pick = subject.tree.championship

      expect(subject.sorted_four.last).to eq(champ_pick.team)
      expect([champ_pick.first_team, champ_pick.second_team]).to include(subject.sorted_four.third)
    end
  end

  describe "#tree / #picks" do
    let(:tree) { subject.tree }
    let(:picks) { subject. picks }

    it "is a tournament tree" do
      expect(tree).to be_a(TournamentTree)
    end

    it "has Game nodes with references to the bracket" do
      picks.each do |pick|
        expect(pick).to be_a(Game)
        expect(pick.bracket).to eq(subject)
      end
    end
  end
end
