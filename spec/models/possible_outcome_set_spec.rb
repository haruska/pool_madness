require "rails_helper"

RSpec.describe PossibleOutcomeSet, type: :model do
  let(:tournament) { create(:tournament, :in_final_four) }
  let(:pool) { create(:pool, tournament: tournament) }
  let!(:brackets) do
    Array.new(3) do
      bracket = create(:bracket, :completed, pool: pool)
      bracket.tree_decisions = tournament.game_decisions
      3.times { |i| bracket.update_choice(i + 1, [0, 1].sample) }
      bracket.save!
      bracket.paid!
      bracket.calculate_points
      bracket.calculate_possible_points
      bracket.bracket_point.update(best_possible: 0)
      bracket
    end
  end

  subject { PossibleOutcomeSet.new(tournament: tournament, exclude_eliminated: true) }

  describe "#all_outcomes_by_winners" do
    let(:outcomes) { subject.all_outcomes_by_winners(pool) }

    it "is a set of possibilities for the pool" do
      expect(outcomes.size).to be > 0
      outcomes.each do |possibility|
        expect(possibility.championships.map(&:class).uniq).to eq([Game])
        expect(possibility.best_brackets.size).to be > 1
        expect(possibility.best_brackets.reduce(&:+)).to match_array(brackets)
      end
    end
  end
end
