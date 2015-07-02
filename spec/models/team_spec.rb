require "spec_helper"

describe Team, type: :model do
  let(:tournament) { create(:tournament) }

  context do
    subject { tournament.teams.order(:starting_slot).first }

    it { should validate_uniqueness_of(:name).scoped_to(:tournament_id) }
    it { should validate_length_of(:name).is_at_most(15) }
    it { should validate_inclusion_of(:region).in_array(Team::REGIONS) }
    it { should validate_uniqueness_of(:seed).scoped_to([:tournament_id, :region]) }
    it do
      should validate_numericality_of(:seed)
        .only_integer
        .is_greater_than_or_equal_to(1)
        .is_less_than_or_equal_to(16)
    end
  end

  describe "#first_game" do
    let(:game) { tournament.round_for(1).sample }

    it "returns the first game the team plays" do
      expect(game.team_one.first_game.slot).to eq(game.slot)
      expect(game.team_two.first_game.slot).to eq(game.slot)
    end
  end

  describe "#still_playing? / #eliminated?" do
    let(:game) { tournament.round_for(1).first }

    subject { game.team_one }

    context "no games are played" do
      it "is true" do
        expect(subject).to be_still_playing
        expect(subject).to_not be_eliminated
      end
    end

    context "won the first game" do
      subject { game.first_team }
      before { tournament.update_game!(game.slot, 0) }

      it "is true" do
        expect(subject).to be_still_playing
        expect(subject).to_not be_eliminated
      end

      context "and won the next game" do
        before { tournament.update_game!(game.parent.slot, 0) }

        it "is true" do
          expect(subject).to be_still_playing
          expect(subject).to_not be_eliminated
        end
      end

      context "lost the next game" do
        before { tournament.update_game!(game.parent.slot, 1) }

        it "is false" do
          expect(subject).to_not be_still_playing
          expect(subject).to be_eliminated
        end
      end

      context "won the championship" do
        let(:tournament) { create(:tournament, :completed) }
        subject { tournament.championship.team }

        it "is true" do
          expect(subject).to_not be_eliminated
          expect(subject).to be_still_playing
        end
      end
    end

    context "lost the first game" do
      subject { game.first_team }
      before { tournament.update_game!(game.slot, 1) }

      it "is false" do
        expect(subject).to_not be_still_playing
        expect(subject).to be_eliminated
      end
    end
  end
end
