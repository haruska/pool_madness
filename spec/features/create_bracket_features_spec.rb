require "rails_helper"

RSpec.describe "Creating a Bracket", js: true do
  let(:tournament) { create(:tournament, :not_started) }
  let(:pool) { create(:pool, tournament: tournament) }
  let(:user) { create(:pool_user, pool: pool).user }

  before do
    sign_in user
    visit "/pools/#{pool.id}"
  end

  it "creates a new bracket in the pool for the current user" do
    click_button "New Bracket Entry"
    expect(page).to have_css(".title", text: "New Bracket")
    expect(page).to have_css("h2", text: "New Bracket Entry")
  end
end
