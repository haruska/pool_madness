require "spec_helper"

describe Pick, type: :model do
  before(:all) { build(:tournament) }
  let(:bracket) { create(:bracket, :completed) }

  subject { bracket.picks.first }

  it { should validate_presence_of(:game) }
  it { should validate_presence_of(:bracket) }

  context "accessible attributes" do
    it "does not allow updating of the bracket" do
      expect { subject.update_attributes(bracket_id: bracket.id) }.to raise_exception
    end
  end

  context "#first_team / #second_team" do
    subject { bracket.picks.find_by_game_id(game.id) }

    context "game is in the first round" do
      let(:game) { Game.round_for(1, Team::REGIONS.first).sample }

      it "is the teams of the associated game" do
        expect(subject.first_team).to eq(game.team_one)
        expect(subject.second_team).to eq(game.team_two)
      end
    end

    context "game is in subsequent rounds" do
      let(:game) { Game.round_for(2, Team::REGIONS.first).sample }
      let(:previous_picks) { [game.game_one_id, game.game_two_id].map {|game_id| bracket.picks.find_by_game_id(game_id) } }

      it "is the winning team of this brackets previous picks" do
        expect(subject.first_team).to eq(previous_picks.first.team)
        expect(subject.second_team).to eq(previous_picks.second.team)
      end
    end
  end

  context "#points" do
    let(:expected_points) { Pick::POINTS_PER_ROUND[game.round] + subject.team.seed }

    context do
      before do
        #set the winner
        game.score_one = 1
        game.score_two = 2
        game.score_one = 3 if game.winner != subject.team
      end

      context "with a possible game" do
        let(:game) { Game.new(team_one: subject.first_team, team_two: subject.second_team) }

        it "uses the outcome of the passed in game" do
          expect(subject.points(game)).to eq(expected_points)
        end
      end

      context "using the actual game" do
        let(:game) { subject.game }

        it "uses the actual outcome of the associated game" do
          expect(subject.points).to eq(expected_points)
        end
      end
    end

    context "there is a picked team" do
      let(:game) { subject.game }

      context "and someone has won the associated game" do
        before do
          #set the winner
          game.score_one = 1
          game.score_two = 2
        end

        context "and the pick is correct" do
          before do
            game.score_one = 3 if game.winner != subject.team
          end

          it "is the team's seed plus the points for the round" do
            expect(subject.points).to eq(Pick::POINTS_PER_ROUND[game.round] + subject.team.seed)
          end
        end

        context "and the pick is incorrect" do
          before do
            game.score_one = 3 if game.winner == subject.team
          end

          it "is zero" do
            expect(subject.points).to eq(0)
          end
        end
      end

      context "there is not a winner yet" do
        it "is zero" do
          expect(subject.points).to eq(0)
        end
      end
    end

    context "team is nil" do
      before { subject.team_id = nil }

      it "is zero" do
        expect(subject.points).to eq(0)
      end
    end
  end

  context "#possible_points" do
    context "there is not a winner yet" do
      context "and the pick's team is still in the tournament" do
        it "is the team's seed plus the points for the round" do
          expect(subject.possible_points).to eq(Pick::POINTS_PER_ROUND[subject.game.round] + subject.team.seed)
        end
      end

      context "and the pick's team is eliminated" do
        let(:team) { subject.team }
        before do
          #eliminate the team
          first_game = team.first_game
          first_game.score_one = 1
          first_game.score_two = 2
          first_game.score_one = 3 if first_game.winner == subject.team
          first_game.save!
        end

        it "is the actual #points" do
          expect(subject.possible_points).to eq(subject.points)
        end
      end
    end

    context "there is a game winner" do
      let(:game) { subject.game }

      before do
        game.score_one = 1
        game.score_two = 2
        game.score_one = 3 if game.winner != subject.team
      end

      it "is the actual #points" do
        expect(subject.possible_points).to eq(subject.points)
      end
    end
  end
end
