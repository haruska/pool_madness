require "spec_helper"

describe BracketsController, type: :controller do
  describe "#show" do
    let!(:tournament) { create(:tournament, :completed) }
    let!(:pool) { create(:pool, tournament: tournament) }
    let!(:bracket) { create(:bracket, :completed, pool: pool) }
    let!(:pool_user) { create(:pool_user, user: bracket.user, pool: pool) }
    let!(:eliminated_team_ids) { tournament.teams.to_a.select(&:eliminated?).map(&:id) }

    let!(:games_played_slots) do
      tournament.games.already_played.map do |game|
        [game.next_game.try(:id), game.next_slot, game.winner.id]
      end
    end

    before do
      sign_in bracket.user
    end

    it "sets the jskit payload" do
      expect(subject).to receive(:set_action_payload).with(eliminated_team_ids, games_played_slots)

      get :show, id: bracket
    end
  end
end
