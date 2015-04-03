require "spec_helper"

describe UpdatePossibleOutcomesJob, type: :job do
  before(:all) { @tournament = create(:tournament, :with_first_two_rounds_completed) }

  let(:pool) { create(:pool, tournament: @tournament) }
  let(:bracket) { create(:bracket, :completed, pool: pool) }

  describe "#perform" do

  end
end
