require "rails_helper"

RSpec.describe Admin::TournamentsController, type: :controller do
  before(:all) { @tournament = create(:tournament) }
  let(:tournament) { @tournament }

  describe "#update_bracket_scores" do
    let(:queue) { ActiveJob::Base.queue_adapter.enqueued_jobs }

    context "as a site admin" do
      let(:user) { create(:user) }

      before do
        user.admin!
        sign_in(user)
      end

      it "enqueues the UpdateAllBracketScoresJob" do
        expect { patch :update_bracket_scores, id: tournament.id }.to change(queue, :size).by(1)
      end

      it "redirects home" do
        patch :update_bracket_scores, id: tournament.id
        expect(response).to redirect_to(tournament_games_path(tournament))
        expect(subject).to set_flash
      end
    end

    context "as a normal user" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it "does not allow access" do
        patch :update_bracket_scores, id: tournament.id
        expect(response).to redirect_to(root_path)
        expect(subject).to set_flash
      end
    end
  end
end
