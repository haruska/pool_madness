require "spec_helper"

describe Bracket, type: :model do
  subject { create(:bracket) }


  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:payment_collector) }
  it { should have_many(:picks) }
  it { should have_one(:charge) }

  it { should validate_presence_of(:user) }
  it { should validate_uniqueness_of(:name) }

  context "accessible attributes" do
    let(:another_user) { create(:user) }

    it "allows setting of tie_breaker, name, points, and possible_points" do
      subject.update_attributes(tie_breaker: 2, name: "new name", points: 10, possible_points: 12)
      subject.reload

      expect(subject.tie_breaker).to eq(2)
      expect(subject.name).to eq("new name")
      expect(subject.points).to eq(10)
      expect(subject.possible_points).to eq(12)
    end

    it "does not allow setting of user_id or payment_collector_id" do
      expect { subject.update_attributes(user_id: another_user.id) }.to raise_exception
      expect { subject.update_attributes(payment_collector_id: another_user.id) }.to raise_exception
    end
  end

  context "after create" do
    let!(:games) { create_list(:game, 5) }

    it "creates all picks" do
      games.each do |game|
        expect(subject.picks.find_by_game_id(game.id)).to be_present
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
      bracket = build(:bracket, user: user)

      expected_name = bracket.default_name

      bracket.save!

      expect(bracket.name).to eq(expected_name)
    end
  end

  context "payment_state state machine" do
    it "starts with :unpaid"

    context "unpaid state" do
      it "is unpaid?"

      context "and a promise_made event is fired" do
        it "transitions to :promised state"
      end

      context "and a payment_recieved event is fired" do
        it "transitions to :paid state"
      end
    end

    context "promised state" do
      it "is promised?"

      context "and a payment_recieved event is fired" do
        it "transitions to :paid state"
      end
    end

    context "paid state" do
      it "is paid?"
    end
  end

  context "#status" do
    context "with an incomplete bracket" do
      it "is :incomplete"
    end

    context "with a complete bracket" do
      context "and it is unpaid" do
        it "is :unpaid"
      end

      context "and it is promised or paid" do
        it "is :ok"
      end
    end
  end

  context "#only_bracket_for_user?" do
    context "when the user has a single bracket" do
      it "returns true"
    end

    context "when the user has multiple brackets" do
      it "returns false"
    end
  end

  context "#default_name" do
    it "is the user's name"
    context "when a bracket with the user's name exists" do
      it "increments an integer and adds it to the end of the name until unique"
    end
  end

  context "#complete? / #incomplete?" do
    it "is complete when all picks are selected and a tie_breaker is set"

    context "when a pick.team is nil" do
      it "is incomplete"
    end

    context "when a pick.team_id is -1" do
      it "is incomplete"
    end

    context "when a tie_breaker is blank" do
      it "is incomplete"
    end
  end

  context "#calculate_points" do
    it "is the sum of all the picks' points"
    it "updates the #points attribute"
  end

  context "#sorted_four" do
    it "is the teams of final four picks of the bracket"
    it "is ordered by champ, second, game_one.loser, game_two.loser"
  end

end
