require "spec_helper"

describe PossibleGame do
  before { build(:tournament, :with_first_two_rounds_completed) }
  let(:slot_bits) { PossibleOutcome.generate_all_slot_bits.sample }
  let(:possible_outcome) { PossibleOutcome.generate_outcome(slot_bits) }

  describe "#siblings_hash" do
    subject { possible_outcome.possible_games.values.sample }

    it "is the possible games hash for the parent outcome" do
      expect(subject.siblings_hash).to eq(possible_outcome.possible_games)
    end
  end

  describe "#siblings" do
    subject { possible_outcome.possible_games.values.sample }

    it "is all the PossibleGames for the parent outcome" do
      expect(subject.siblings).to eq(possible_outcome.possible_games.values)
    end
  end

  describe "#game_one / #game_two" do
    context "in the second round" do
      subject { possible_outcome.round_for(2).sample }

      it "is the possible game for #game.game_n" do
        expect(subject.game_one).to be_a(PossibleGame)
        expect(subject.game_one.game).to eq(subject.game.game_one)

        expect(subject.game_two).to be_a(PossibleGame)
        expect(subject.game_two.game).to eq(subject.game.game_two)
      end
    end

    context "in the first round" do
      subject { possible_outcome.round_for(1).sample }

      it "is nil" do
        expect(subject.game_one).to be_nil
        expect(subject.game_two).to be_nil
      end
    end
  end

  describe "#first_team / #second_team" do
    context "in the first round" do
      subject { possible_outcome.round_for(1).sample }

      it "is the associated teams" do
        expect(subject.first_team).to eq(subject.game.team_one)
        expect(subject.second_team).to eq(subject.game.team_two)
      end
    end

    context "in subsequent rounds" do
      subject { possible_outcome.round_for(2).sample }

      it "is the winner of the associated games" do
        expect(subject.first_team).to eq(subject.game_one.winner)
        expect(subject.second_team).to eq(subject.game_two.winner)
      end
    end
  end

  describe "#winner" do
    subject { possible_outcome.possible_games.values.sample }

    let(:expected_winner) { subject.score_one > subject.score_two ? subject.first_team : subject.second_team }

    it "is the winning team" do
      expect(subject.winner).to eq(expected_winner)
    end
  end

  describe "#next_slot" do
    context "when it is game_one in the next round" do
      subject { possible_outcome.round_for(2).first.game_one }

      it "is 1" do
        expect(subject.next_slot).to eq(1)
      end
    end

    context "when it is game_two in the next round" do
      subject { possible_outcome.round_for(2).first.game_two }

      it "is 2" do
        expect(subject.next_slot).to eq(2)
      end
    end

    context "when there isn't another round (championship)" do
      subject { possible_outcome.championship }

      it "is nil" do
        expect(subject.next_slot).to be_nil
      end
    end
  end

  describe "#next_game" do
    let(:next_game) { possible_outcome.round_for(2).sample }

    context "when subject is in slot one" do
      subject { next_game.game_one }

      it "is the next round game for the winner" do
        expect(subject.next_game).to eq(next_game)
      end
    end
    context "when subject is in slot two" do
      subject { next_game.game_two }

      it "is the next round game for the winner" do
        expect(subject.next_game).to eq(next_game)
      end

    end
  end

  describe "#points_for_pick" do
    subject { possible_outcome.round_for(3).sample }

    context "when team_id is the winning team" do
      let(:team_id) { subject.winner.id }

      it "is the points for the round + seed" do
        expect(subject.points_for_pick(team_id)).to eq(Pick::POINTS_PER_ROUND[3] + subject.winner.seed)
      end

    end

    context "when team_id is the losing team" do
      let(:team_id) { subject.winner == subject.first_team ? subject.second_team.id : subject.first_team.id }

      it "is 0" do
        expect(subject.points_for_pick(team_id)).to eq(0)
      end
    end
  end

  describe "#round" do
    let(:championship) { possible_outcome.round_for(6).first }

    context "championship" do
      subject { championship }

      it "is 6" do
        expect(subject.round).to eq(6)
      end
    end

    context "previous rounds" do
      it "is the current round number between 1-5" do
        possible_game = championship.game_one
        round = 5
        while round > 0
          expect(possible_game.round).to eq(round)
          possible_game = possible_game.game_one
          round -= 1
        end
      end
    end
  end
end
