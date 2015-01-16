require "spec_helper"

describe Game, type: :model do
  subject { create(:game) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it { should belong_to(:team_one) }
  it { should belong_to(:team_two) }
  it { should belong_to(:game_one) }
  it { should belong_to(:game_two) }

  describe "#first_team / #second_team" do
    context "in the first round" do
      it "is the associated teams"
    end

    context "in subsequent rounds" do
      it "is the winner of the associated games"
    end
  end

  describe "#winner" do
    context "when the game hasn't been played" do
      it "is nil"
    end

    context "after the game is completed" do
      it "is the winning team"
    end
  end

  describe "#next_slot" do
    context "when it is game_one in the next round" do
      it "is 1"
    end

    context "when it is game_two in the next round" do
      it "is 2"
    end

    context "when there isn't another round (championship)" do
      it "is nil"
    end
  end

  describe "#round" do
    context "championship" do
      it "is 6"
    end

    context "previous rounds" do
      it "is the current round number between 1-5"
    end
  end

  describe "Game#championship" do
    it "returns the championship game"
  end

  describe "Game#round_for" do
    context "round 1" do
      it "returns games for the region ordered by team seed (1,8,5,4,6,3,7,2)"
    end
    context "round 5" do
      it "returns the semi-final games"
    end

    context "round 6" do
      it "returns a singleton list of the championship game"
    end

    context "other rounds" do
      it "returns the previous round_for's next_games"
    end
  end
end
