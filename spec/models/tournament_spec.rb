require "spec_helper"

describe Tournament, type: :model do
  before(:all) { @tournament = create(:tournament) }
  subject { @tournament }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  describe "#championship" do
    let(:expected_game) { subject.tree.at(1) }

    it "returns the championship game" do
      expect(subject.championship.slot).to eq(expected_game.slot)
    end
  end

  describe "#round_for" do
    let(:region) { Team::REGIONS.first }

    context "round 1" do
      let(:expected_games) do
        [1, 8, 5, 4, 6, 3, 7, 2].map do |seed|
          subject.teams.find_by(region: region, seed: seed).first_game
        end
      end

      it "returns games for the region ordered by team seed (1,8,5,4,6,3,7,2)" do
        expect(subject.round_for(1, region).map(&:slot)).to eq(expected_games.map(&:slot))
      end
    end

    context "round 5" do
      it "returns the semi-final games" do
        expect(subject.round_for(5).map(&:slot)).to eq([subject.championship.game_one.slot, subject.championship.game_two.slot])
      end
    end

    context "round 6" do
      it "returns a singleton list of the championship game" do
        expect(subject.round_for(6).map(&:slot)).to eq([subject.championship.slot])
      end
    end

    context "other rounds" do
      it "returns the previous round_for's next_games" do
        (2..4).each do |round|
          expected_games = subject.round_for(round - 1, region).map(&:next_game).uniq
          expect(subject.round_for(round, region).map(&:slot)).to eq(expected_games.map(&:slot))
        end
      end
    end
  end
end
