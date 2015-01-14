require "spec_helper"

describe Pick, type: :model do
  subject { create(:pick) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it { should validate_presence_of(:game) }
  it { should validate_presence_of(:bracket) }

  context "accessible attributes" do
    let(:game) { create(:game) }
    let(:team) { create(:team) }
    let(:bracket) { create(:bracket) }

    it "allows updating of the game and team" do
      subject.update_attributes(game_id: game.id, team_id: team.id)
      subject.reload

      expect(subject.game).to eq(game)
      expect(subject.team).to eq(team)
    end

    it "does not allow updating of the bracket" do
      expect { subject.update_attributes(bracket_id: bracket.id) }.to raise_exception
    end
  end

  context "#first_team" do
    context "game is in the first round" do
      it "is the team_one of the associated game"
    end

    context "game is in subsequent rounds" do
      it "is the winning team of this brackets previous pick (game_one)"
    end
  end

  context "#second_team" do
    context "game is in the first round" do
      it "is the team_two of the associated game"
    end

    context "game is in subsequent rounds" do
      it "is the winning team of this brackets previous pick (game_two)"
    end
  end

  context "#points" do
    context "with a possible game" do
      it "uses the outcome of the passed in game"
    end

    context "using the actual game" do
      it "uses the actual outcome of the associated game"
    end

    context "there is a picked team" do
      context "and someone has one the associated game" do
        context "and the pick is correct" do
          it "is the team's seed plus the points for the round"
        end

        context "and the pick is incorrect" do
          it "is zero"
        end
      end

      context "there is not a winner yet" do
        it "is zero"
      end
    end

    context "team is nil" do
      it "is zero"
    end
  end

  context "#possible_points" do
    context "there is not a winner yet" do
      context "and the pick's team is still in the tournament" do
        it "is the team's seed plus the points for the round"
      end

      context "and the pick's team is eliminated" do
        it "is the actual #points"
      end
    end

    context "there is a game winner" do
      it "is the actual #points"
    end
  end
end
