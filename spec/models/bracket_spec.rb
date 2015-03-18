require "spec_helper"

describe Bracket, type: :model do
  before(:all) { @tournament = create(:tournament) }

  let(:tournament) { @tournament }
  let(:pool) { create(:pool, tournament: tournament) }

  subject { create(:bracket, pool: pool) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:payment_collector) }
  it { should have_many(:picks) }

  it { should validate_presence_of(:user) }
  it { should validate_uniqueness_of(:name).scoped_to(:pool_id) }

  context "after create" do
    it "creates all picks" do
      tournament.games.each do |game|
        expect(subject.picks.find_by(game_id: game.id)).to be_present
      end
    end
  end

  context "before validation" do
    it "resets tie_breaker to nil if it is <= 0" do
      subject.tie_breaker = 0
      expect(subject).to be_valid
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
    context "with an incomplete bracket" do
      it "is :incomplete" do
        expect(subject.status).to eq(:incomplete)
      end
    end

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
      expect(subject.picks.where(team_id: nil)).to be_empty
      expect(subject.tie_breaker).to be > 0

      expect(subject).to be_complete
    end

    context "when a pick.team is nil" do
      subject { create(:bracket, pool: pool) }

      it "is incomplete" do
        expect(subject).to be_incomplete
      end
    end

    context "when a pick.team_id is -1" do
      before { subject.picks.to_a.sample.update_attributes!(team_id: -1) }

      it "is incomplete" do
        expect(subject).to be_incomplete
      end
    end

    context "when a tie_breaker is blank" do
      before { subject.update_attributes!(tie_breaker: nil) }

      it "is incomplete" do
        expect(subject).to be_incomplete
      end
    end
  end

  context "#sorted_four" do
    subject { create(:bracket, :completed, pool: pool) }

    it "is the teams of final four picks of the bracket" do
      semifinal_games = [tournament.championship.game_one, tournament.championship.game_two]
      semifinal_picks = subject.picks.where(game_id: semifinal_games.map(&:id))
      expected_teams = semifinal_picks.map { |pick| [pick.first_team, pick.second_team] }.flatten

      expected_teams.each { |team| expect(subject.sorted_four).to include(team) }
    end

    it "is reverse-ordered with champ and 2nd place at the end" do
      champ_pick = subject.picks.find_by(game_id: tournament.championship.id)

      expect(subject.sorted_four.last).to eq(champ_pick.team)
      expect([champ_pick.first_team, champ_pick.second_team]).to include(subject.sorted_four.third)
    end
  end
end
