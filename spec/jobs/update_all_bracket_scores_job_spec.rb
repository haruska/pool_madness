require 'spec_helper'

describe UpdateAllBracketScoresJob, type: :job do
  before(:all) { @tournament = create(:tournament, :with_first_two_rounds_completed) }

  let(:pool) { create(:pool, tournament: @tournament) }
  let!(:brackets) { create_list(:bracket, 3, :completed, pool: pool) }

  describe "#perform" do
    let(:queue) { ActiveJob::Base.queue_adapter.enqueued_jobs }

    it "enqueues BracketScoreJob for each bracket" do
      expect { subject.perform }.to change(queue, :size).by(brackets.size)
    end
  end
end
