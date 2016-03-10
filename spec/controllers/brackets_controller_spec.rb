require "rails_helper"

RSpec.describe BracketsController, type: :controller do
  describe "#show" do
    let(:tournament) { create(:tournament, :completed) }
    let(:pool) { create(:pool, tournament: tournament) }
    let(:bracket) { create(:bracket, :completed, pool: pool) }

    before do
      sign_in bracket.user
    end

    it "sets the jskit payload" do
      expect(subject).to receive(:set_action_payload).with(bracket.id, bracket.games_hash, bracket.tie_breaker)

      get :show, id: bracket
    end
  end
end
