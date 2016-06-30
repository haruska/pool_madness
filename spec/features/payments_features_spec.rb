require "rails_helper"

RSpec.describe "Payments", js: true do
  let(:user) { create(:user) }
  let(:tournament) { create(:tournament, :not_started) }
  let(:pool) { create(:pool, tournament: tournament) }
  let!(:brackets) { create_list(:bracket, 3, :completed, user: user, pool: pool) }
  let!(:unfinished_bracket) { create(:bracket, user: user, pool: pool) }

  before do
    sign_in user
    visit "/pools/#{pool.id}"
    click_button "Pay Now"
  end

  it "shows a form to pay for all unpaid completed brackets" do
    within_frame(find(".stripe_checkout_app")) do
      expect(page).to have_selector(".title h1", text: "Pool Madness")
      expect(page).to have_selector(".title h2", text: "3 brackets")
      expect(page).to have_selector(".loggedBarContent span", text: user.email)
      expect(page).to_not have_link("Log out")
      expect(page).to have_button("Pay $30.00")
    end
  end
end
