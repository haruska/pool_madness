require "spec_helper"

describe BracketsController, type: :controller do
  describe "#show" do
    let!(:tournament) { create(:tournament, :completed) }
    let!(:pool) { create(:pool, tournament: tournament) }
    let!(:bracket) { create(:bracket, :completed, pool: pool) }
    let!(:pool_user) { create(:pool_user, user: bracket.user, pool: pool) }

    before do
      sign_in bracket.user
    end

    it "sets the jskit payload" do
      expect(subject).to receive(:set_action_payload).with(bracket.id, js_games(bracket))

      get :show, id: bracket
    end
  end

  private

  def js_games(bracket)
    tree = bracket.tree
    (1..bracket.tournament.num_games).map do |slot|
      node = tree.at(slot)
      {
          id: slot,
          teamOne: team_hash(node.team_one),
          teamTwo: team_hash(node.team_two),
          winningTeam: team_hash(node.game.winner),
          gameOneId: node.left_position,
          gameTwoId: node.right_position,
          nextGameId: node.next_game_slot,
          nextSlot: node.next_slot,
          pickId: slot,
          choice: node.decision
      }
    end
  end

  def team_hash(team)
    team.present? ? { id: team.id, seed: team.seed, name: team.name } : nil
  end
end
