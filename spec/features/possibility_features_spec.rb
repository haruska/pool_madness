require "rails_helper"

RSpec.describe "Viewing pool possibilities", js: true do
  let(:tournament) { create(:tournament, :in_final_four) }
  let(:pool) { create(:pool, tournament: tournament) }
  let!(:brackets) { create_list(:bracket, 3, :winning, pool: pool) }
  let(:user) { brackets.sample.user }
  let(:outcome_set) { PossibleOutcomeSet.new(tournament: tournament, exclude_eliminated: true) }
  let(:outcomes) { outcome_set.all_outcomes_by_winners(pool) }

  before do
    sign_in user
    visit "/pools/#{pool.id}/possibilities"
  end

  it "shows all outcomes and their winners" do
    expect(page).to have_css("h1", text: "#{pool.name} Pool Possibilities")
    outcomes.each do |possibility|
      expect(possibility.championships).to be_present
      possibility.championships.each do |possible_game|
        expect(page).to have_css("h3", text: "#{possible_game.winner.name} BEATS #{possible_game.loser.name}")
      end
      expect(possibility.best_brackets).to be_present
      possibility.best_brackets.each do |brackets|
        expect(page).to have_css("li", text: /#{brackets.map(&:name).join(", ")}/i)
      end
    end
  end
end
