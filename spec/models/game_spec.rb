require "spec_helper"

describe Game, type: :model do
  before(:all) { @tournament = create(:tournament, :completed) }
  let(:tournament) { @tournament }
  let(:tournament_tree) { tournament.tree }

  describe "aliased methods" do
    let(:slot) { rand(tournament_tree.size - 1) + 1 }
    subject { tournament_tree.at(slot) }

    it "is a BDT node" do
      expect(subject).to be_a(Game)
      expect(subject).to be_a(BinaryDecisionTree::Node)
    end

    it "knows it's current round (depth)" do
      expect(subject.round).to eq(subject.current_depth)
    end

    it "has a game_one, game_two, and next_game" do
      expect(subject.game_one).to eq(subject.left)
      expect(subject.game_two).to eq(subject.right)
      expect(subject.next_game).to eq(subject.parent)
    end
  end

  describe "#championship?" do
    context "championship game" do
      subject { tournament_tree.championship }

      it "is true" do
        expect(subject).to be_championship
      end
    end

    context "non-championship game" do
      subject { tournament_tree.round_for(1).sample }

      it "is false" do
        expect(subject).to_not be_championship
      end
    end
  end

  describe "#tournament_game" do
    let(:slot) { rand(tournament_tree.size - 1) + 1 }

    context "in a tournament" do
      subject { tournament_tree.at(slot) }

      it "is itself" do
        expect(subject.tournament_game).to eq(subject)
      end
    end

    context "in a bracket" do
      let(:pool) { create(:pool, tournament: tournament) }
      let(:bracket) { create(:bracket, pool: pool) }

      subject { bracket.tree.at(slot) }

      it "is the corresponding tournament game" do
        expect(subject.tournament_game).to_not eq(subject)
        expect(subject.tournament_game).to eq(tournament_tree.at(slot))
      end
    end
  end

  describe "#next_slot" do
    let(:parent) { tournament_tree.round_for(2).sample }

    context "championship game" do
      subject { tournament_tree.championship }

      it "is nil" do
        expect(subject.next_slot).to be_nil
      end
    end

    context "game is parent's left slot" do
      subject { parent.left }

      it "is 1" do
        expect(subject.next_slot).to eq(1)
      end
    end

    context "game is parent's right slot" do
      subject { parent.right }

      it "is 2" do
        expect(subject.next_slot).to eq(2)
      end
    end
  end

  describe "#next_game_slot" do
    context "championship game" do
      subject { tournament_tree.championship }

      it "is nil" do
        expect(subject.next_game_slot).to be_nil
      end
    end

    context "non-championship game" do
      subject { tournament_tree.round_for(1).sample }

      it "is the parent_position" do
        expect(subject.next_game_slot).to eq(subject.parent_position)
      end
    end
  end

  describe "#team_one" do
    context "a leaf node" do
      subject { tournament_tree.round_for(1).sample }

      it "is the team with the left_position starting slot" do
        expect(subject.team_one).to eq(tournament.teams.find_by(starting_slot: subject.left_position))
      end
    end

    context "a non-leaf node" do
      subject { tournament_tree.round_for(2).sample }

      it "is nil" do
        expect(subject.team_one).to be_nil
      end
    end
  end

  describe "#team_two" do
    context "a leaf node" do
      subject { tournament_tree.round_for(1).sample }

      it "is the team with the right_position starting slot" do
        expect(subject.team_two).to eq(tournament.teams.find_by(starting_slot: subject.right_position))
      end
    end

    context "a non-leaf node" do
      subject { tournament_tree.round_for(2).sample }

      it "is nil" do
        expect(subject.team_two).to be_nil
      end
    end
  end

  describe "#first_team" do
    context "a leaf node" do
      subject { tournament_tree.round_for(1).sample }

      it "is team_one" do
        expect(subject.first_team).to eq(subject.team_one)
      end
    end

    context "a non-leaf node" do
      subject { tournament_tree.round_for(2).sample }

      it "is the left team of the current game" do
        expect(subject.first_team).to eq(subject.left.team)
      end
    end
  end

  describe "#second_team" do
    context "a leaf node" do
      subject { tournament_tree.round_for(1).sample }

      it "is team_two" do
        expect(subject.second_team).to eq(subject.team_two)
      end
    end

    context "a non-leaf node" do
      subject { tournament_tree.round_for(3).sample }

      it "is the right team of the current game" do
        expect(subject.second_team).to eq(subject.right.team)
      end
    end
  end

  describe "#team" do
    subject { tournament_tree.round_for(1).sample }

    it "is the team with the current starting slot" do
      expect(subject.team).to eq(tournament.teams.find_by(starting_slot: subject.value))
    end
  end

  describe "#points" do
    context "with a possible_game" do
      context "and the winner was picked" do
        it "is the points per round + the team seed"
      end

      context "and the winner was not picked" do
        it "is zero"
      end
    end

    context "without a possible_game" do
      context "and the game has a winner" do
        context "and the winner was picked" do
          it "is the points per round + the team seed"
        end

        context "and the winner was not picked" do
          it "is zero"
        end
      end

      context "and there is no winner" do
        it "is zero"
      end
    end
  end

  describe "#possible_points" do
    context "the game has a winner" do
      it "is the actual points"
    end

    context "the game does not have a winner" do
      context "the picked team is still playing" do
        it "is the points per round + the team seed"
      end

      context "the picked team is eliminated" do
        it "is the actual points"
      end
    end
  end
end
