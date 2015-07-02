require "spec_helper"

describe BracketScoreJob, type: :job do
  # before(:all) { @tournament = create(:tournament, :with_first_two_rounds_completed) }
  #
  # let(:pool) { create(:pool, tournament: @tournament) }
  # let(:bracket) { create(:bracket, :completed, pool: pool) }
  #
  # describe "#perform" do
  #   before { subject.perform(bracket.id) }
  #
  #   it "updates the current score of the bracket" do
  #     expect(bracket.reload.points).to_not be_zero
  #   end
  #
  #   it "updates the possible score of the bracket" do
  #     expect(bracket.reload.possible_points).to_not be_zero
  #   end
  # end
end
