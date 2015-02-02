require "spec_helper"

describe Game, type: :model do
  before(:all) { build(:tournament) }

  context do
    subject { Game.first }

    it "has a valid factory" do
      expect(subject).to be_valid
    end

    it { should belong_to(:team_one) }
    it { should belong_to(:team_two) }
    it { should belong_to(:game_one) }
    it { should belong_to(:game_two) }
  end

  describe "scopes" do
    before do
      (1..2).each do |round|
        Team::REGIONS.each do |region|
          Game.round_for(round, region).each do |game|
            while game.score_one.nil? || game.score_one == game.score_two
              game.update_attributes(score_one: rand(100) + 1, score_two: rand(100) + 1)
            end
          end
        end
      end
    end

    after do
      (1..2).each do |round|
        Team::REGIONS.each do |region|
          Game.round_for(round, region).each do |game|
            game.update_attributes(score_one: nil, score_two: nil)
          end
        end
      end
    end

    describe "already_played" do
      let(:played_games) { (1..2).map {|round| Team::REGIONS.map { |region| Game.round_for(round, region) }}.flatten }

      it "is a set of all games with a score" do
        expect(Game.already_played.to_a).to match_array(played_games)
      end

      it "is ordered by ID" do
        expect(Game.already_played.map(&:id)).to eq(Game.already_played.map(&:id).sort)
      end
    end

    describe "not_played" do
      it "is a set of all games not played"
      it "is ordered by ID"
    end
  end

  describe "#first_team / #second_team" do
    context "in the first round" do
      subject { Game.first }

      it "is the associated teams" do
        expect(subject.first_team).to eq(subject.team_one)
        expect(subject.second_team).to eq(subject.team_two)
      end
    end

    context "in subsequent rounds" do
      subject { Game.first.next_game }

      before do
        [subject.game_one, subject.game_two].each do |game|
          game.update_attributes(score_one: 1, score_two: 0)
        end
      end

      after do
        [subject.game_one, subject.game_two].each do |game|
          game.update_attributes(score_one: nil, score_two: nil)
        end
      end

      it "is the winner of the associated games" do
        expect(subject.first_team).to eq(subject.game_one.winner)
        expect(subject.second_team).to eq(subject.game_two.winner)
      end
    end
  end

  describe "#winner" do
    subject { Game.first }

    context "when the game hasn't been played" do
      it "is nil" do
        expect(subject.winner).to be_nil
      end
    end

    context "after the game is completed" do
      before { subject.update_attributes(score_one: 1, score_two: 2) }
      after { subject.update_attributes(score_one: nil, score_two: nil) }

      it "is the winning team" do
        expect(subject.winner).to eq(subject.team_two)
      end
    end
  end

  describe "#next_slot" do
    context "when it is game_one in the next round" do
      subject { Game.first.next_game.game_one }
      it "is 1" do
        expect(subject.next_slot).to eq(1)
      end
    end

    context "when it is game_two in the next round" do
      subject { Game.first.next_game.game_two }

      it "is 2" do
        expect(subject.next_slot).to eq(2)
      end
    end

    context "when there isn't another round (championship)" do
      subject { Game.championship }

      it "is nil" do
        expect(subject.next_slot).to be_nil
      end
    end
  end

  describe "#round" do
    context "championship" do
      subject { Game.championship }

      it "is 6" do
        expect(subject.round).to eq(6)
      end
    end

    context "previous rounds" do
      it "is the current round number between 1-5" do
        game = Game.championship.game_one
        round = 5
        while round > 0
          expect(game.round).to eq(round)
          game = game.game_one
          round -= 1
        end
      end

    end
  end

  describe "Game#championship" do
    let(:expected_game) { Game.all.to_a.find {|g| g.next_game.blank? } }

    it "returns the championship game" do
      expect(Game.championship).to eq(expected_game)
    end
  end

  describe "Game#round_for" do
    let(:region) { Team::REGIONS.first }

    context "round 1" do
      let(:expected_games) do
        [1, 8, 5, 4, 6, 3, 7, 2].map do |seed|
          Team.where(region: region).find_by_seed(seed).first_game
        end
      end

      it "returns games for the region ordered by team seed (1,8,5,4,6,3,7,2)" do
        expect(Game.round_for(1, region)).to eq(expected_games)
      end
    end

    context "round 5" do
      it "returns the semi-final games" do
        expect(Game.round_for(5)).to eq([Game.championship.game_one, Game.championship.game_two])
      end
    end

    context "round 6" do
      it "returns a singleton list of the championship game" do
        expect(Game.round_for(6)).to eq([Game.championship])
      end
    end

    context "other rounds" do
      it "returns the previous round_for's next_games" do
        (2..4).each do |round|
          expected_games = Game.round_for(round - 1, region).map(&:next_game).uniq
          expect(Game.round_for(round, region)).to eq(expected_games)
        end
      end
    end
  end
end
