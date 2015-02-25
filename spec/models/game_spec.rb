require "spec_helper"

describe Game, type: :model do
  before(:all) {
    @tournament = create(:tournament, :with_first_two_rounds_completed)
  }

  let(:tournament) { @tournament }

  context do
    subject { tournament.games.first }

    it "has a valid factory" do
      expect(subject).to be_valid
    end

    it { should belong_to(:team_one) }
    it { should belong_to(:team_two) }
    it { should belong_to(:game_one) }
    it { should belong_to(:game_two) }
  end

  describe "scopes" do
    let(:played_games) { (1..2).map {|round| Team::REGIONS.map { |region| tournament.round_for(round, region) }}.flatten }
    let(:not_played_games) { tournament.games.where("id NOT IN (?)", played_games.map(&:id)) }

    describe "already_played" do
      it "is a set of all games with a score" do
        expect(tournament.games.already_played.to_a).to match_array(played_games)
      end
    end

    describe "not_played" do
      it "is a set of all games not played" do
        expect(tournament.games.not_played.to_a).to match_array(not_played_games)
      end
    end
  end

  describe "#first_team / #second_team" do
    context "in the first round" do
      subject { tournament.round_for(1).first }

      it "is the associated teams" do
        expect(subject.first_team).to eq(subject.team_one)
        expect(subject.second_team).to eq(subject.team_two)
      end
    end

    context "in subsequent rounds" do
      subject { tournament.round_for(2).first }

      before do
        [subject.game_one, subject.game_two].each do |game|
          game.update_attributes(score_one: 1, score_two: 0)
        end
      end

      it "is the winner of the associated games" do
        expect(subject.first_team).to eq(subject.game_one.winner)
        expect(subject.second_team).to eq(subject.game_two.winner)
      end
    end
  end

  describe "#winner" do
    context "when the game hasn't been played" do
      subject { tournament.round_for(3).first }

      it "is nil" do
        expect(subject.winner).to be_nil
      end
    end

    context "after the game is completed" do
      subject { tournament.round_for(1).first }
      let(:expected_winner) { subject.score_one > subject.score_two ? subject.team_one : subject.team_two }

      it "is the winning team" do
        expect(subject.winner).to eq(expected_winner)
      end
    end
  end

  describe "#next_game" do
    let(:next_game) { tournament.round_for(2).sample }

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

  describe "#next_slot" do
    context "when it is game_one in the next round" do
      subject { tournament.round_for(2).first.game_one }

      it "is 1" do
        expect(subject.next_slot).to eq(1)
      end
    end

    context "when it is game_two in the next round" do
      subject { tournament.round_for(2).first.game_two }

      it "is 2" do
        expect(subject.next_slot).to eq(2)
      end
    end

    context "when there isn't another round (championship)" do
      subject { tournament.championship }

      it "is nil" do
        expect(subject.next_slot).to be_nil
      end
    end
  end

  describe "#round" do
    context "championship" do
      subject { tournament.championship }

      it "is 6" do
        expect(subject.round).to eq(6)
      end
    end

    context "previous rounds" do
      it "is the current round number between 1-5" do
        game = tournament.championship.game_one
        round = 5
        while round > 0
          expect(game.round).to eq(round)
          game = game.game_one
          round -= 1
        end
      end
    end
  end
end
