require "rails_helper"

RSpec.describe "Game Results", js: true do
  let(:tournament) { create(:tournament, :completed) }
  let(:pool) { create(:pool, tournament: tournament) }
  let(:user) { create(:pool_user, pool: pool).user }

  before do
    sign_in user
    visit pool_games_path(pool)
  end

  it "shows a filled out bracket with the winners" do
    champ_name = tournament.championship.team.name
    expect(champ_name).to be_present

    expect(page).to have_css(".champion-box", text: champ_name)
  end
end
