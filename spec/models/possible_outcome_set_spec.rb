require "rails_helper"

RSpec.describe PossibleOutcomeSet, type: :model do
  let(:tournament) { create(:tournament, :in_final_four) }
  let(:pool) { create(:pool, tournament: tournament) }
  let!(:brackets) { create_list(:bracket, 3, :winning, pool: pool) }

  subject { PossibleOutcomeSet.new(tournament: tournament, exclude_eliminated: true) }

  describe "#all_outcomes_by_winners" do
    let(:outcomes) { subject.all_outcomes_by_winners(pool) }

    it "is a set of possibilities for the pool" do
      expect(outcomes.size).to be > 0
      outcomes.each do |possibility|
        expect(possibility.championships.map(&:class).uniq).to eq([Game])
        expect(possibility.best_brackets.size).to be >= 1
        expect(possibility.best_brackets.map(&:to_a).reduce(&:+)).to match_array(brackets)
      end
    end
  end
end
