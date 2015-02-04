require "spec_helper"

describe Team, type: :model do
  before { build(:tournament) }

  context do
    subject { Game.first.team_one }

    it { should validate_uniqueness_of(:name) }
    # it { should validate_length_of(:name).is_at_most(15) } # Uncomment with latest version of shoulda-matchers
    it { should validate_inclusion_of(:region).in_array(Team::REGIONS) }
    it { should validate_numericality_of(:seed)
                    .only_integer.is_greater_than_or_equal_to(1)
                    .is_less_than_or_equal_to(16) }
    it { should validate_uniqueness_of(:seed).scoped_to(:region) }
  end

  describe "#first_game" do
    let(:game) { Game.where("team_two_id is not null").first }

    it "returns the first game the team plays" do
      expect(game.team_one.first_game).to eq(game)
      expect(game.team_two.first_game).to eq(game)
    end
  end

  describe "#still_playing? / #eliminated?" do
    let(:game) { Game.round_for(1).sample }

    subject { game.team_one }

    context "no games are played" do
      it "is true" do
        expect(subject).to be_still_playing
        expect(subject).to_not be_eliminated
      end
    end

    context "won the first game" do
      before { game.update_attributes(score_one: 2, score_two: 1) }

      it "is true" do
        expect(subject).to be_still_playing
        expect(subject).to_not be_eliminated
      end

      context "and won the next game" do
        before { game.next_game.update_attributes(score_one: 2, score_two: 1) }

        it "is true" do
          expect(subject).to be_still_playing
          expect(subject).to_not be_eliminated
        end
      end

      context "lost the next game" do
        before do
          game.next_game.update_attributes(score_one: 1, score_two: 2)
          game.next_game.game_two.update_attributes(score_one: 1, score_two: 2)
        end

        it "is false" do
          expect(subject).to_not be_still_playing
          expect(subject).to be_eliminated
        end
      end
    end

    context "lost the first game" do
      before { game.update_attributes(score_one: 1, score_two: 2) }

      it "is false" do
        expect(subject).to_not be_still_playing
        expect(subject).to be_eliminated
      end
    end
  end
end
