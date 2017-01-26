require "rails_helper"

RSpec.describe PossibleOutcome do
  let(:tournament) { create(:tournament, :in_final_four) }
  let(:pool) { create(:pool, tournament: tournament) }
  let!(:brackets) { create_list(:bracket, 3, :winning, pool: pool) }

  let(:possible_outcome_set) { PossibleOutcomeSet.new(tournament: tournament, exclude_eliminated: true) }
  subject { possible_outcome_set.all_outcomes.sample }

  describe "#get_best_possible" do
    let(:best_possible) { subject.get_best_possible(pool) }

    it "is a list of brackets ordered by index" do
      expect(best_possible.map(&:first)).to match_array(brackets)
    end
  end
end
