require "spec_helper"

describe Pick, type: :model do
  before(:all) do
    @tournament = create(:tournament, :with_first_two_rounds_completed)
  end

  let(:tournament) { @tournament }
  let(:pool) { create(:pool, tournament: tournament) }

  let(:bracket) { create(:bracket, :completed, pool: pool) }
  let(:game) { tournament.round_for(1).sample }

  subject { bracket.picks.find_by(game_id: game.id) }

  it { should validate_presence_of(:game) }
  it { should validate_presence_of(:bracket) }

  context "#first_team / #second_team" do
    context "game is in the first round" do
      it "is the teams of the associated game" do
        expect(subject.first_team).to eq(game.team_one)
        expect(subject.second_team).to eq(game.team_two)
      end
    end

    context "game is in subsequent rounds" do
      let(:game) { tournament.round_for(2).sample }
      let(:previous_picks) { [game.game_one_id, game.game_two_id].map { |game_id| bracket.picks.find_by(game_id: game_id) } }

      it "is the winning team of this brackets previous picks" do
        expect(subject.first_team).to eq(previous_picks.first.team)
        expect(subject.second_team).to eq(previous_picks.second.team)
      end
    end
  end

  context "#points" do
    let(:expected_points) { Pick::POINTS_PER_ROUND[game.round] + subject.team.seed }

    context do
      before { game.update_attributes(score_one: game.score_two, score_two: game.score_one) if game.winner != subject.team }

      context "with a possible game" do
        it "uses the outcome of the passed in game" do
          expect(subject.points(game)).to eq(expected_points)
        end
      end

      context "using the actual game" do
        it "uses the actual outcome of the associated game" do
          expect(subject.points).to eq(expected_points)
        end
      end
    end

    context "there is a picked team" do
      context "and someone has won the associated game" do
        context "and the pick is correct" do
          before { game.update_attributes(score_one: game.score_two, score_two: game.score_one) if game.winner != subject.team }

          it "is the team's seed plus the points for the round" do
            expect(subject.points).to eq(Pick::POINTS_PER_ROUND[game.round] + subject.team.seed)
          end
        end

        context "and the pick is incorrect" do
          before { game.update_attributes(score_one: game.score_two, score_two: game.score_one) if game.winner == subject.team }

          it "is zero" do
            expect(subject.points).to eq(0)
          end
        end
      end

      context "there is not a winner yet" do
        let(:game) { tournament.round_for(3).sample }

        it "is zero" do
          expect(subject.points).to eq(0)
        end
      end
    end

    context "team is nil" do
      before { subject.update_attributes(team_id: nil) }

      it "is zero" do
        expect(subject.points).to eq(0)
      end
    end
  end

  context "#possible_points" do
    context "there is not a winner yet" do
      let(:game) { tournament.round_for(3).sample }
      let(:team) { subject.team }

      context "and the pick's team is still in the tournament" do
        before do
          [team.first_game, team.first_game.next_game].each do |g|
            g.update_attributes(score_one: g.score_two, score_two: g.score_one) if g.winner != subject.team
          end
        end

        it "is the team's seed plus the points for the round" do
          expect(subject.possible_points).to eq(Pick::POINTS_PER_ROUND[subject.game.round] + subject.team.seed)
        end
      end

      context "and the pick's team is eliminated" do
        # eliminate the team
        before { team.first_game.update_attributes(score_one: team.first_game.score_two, score_two: team.first_game.score_one) if team.first_game.winner == subject.team }

        it "is the actual #points" do
          expect(subject.possible_points).to eq(subject.points)
        end
      end
    end

    context "there is a game winner" do
      it "is the actual #points" do
        expect(subject.possible_points).to eq(subject.points)
      end
    end
  end
end
