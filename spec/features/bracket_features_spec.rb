require "rails_helper"

RSpec.describe "Viewing a bracket", js: true do
  let!(:bracket) { create(:bracket, :completed) }
  let(:pool) { bracket.pool }
  let(:user) { bracket.user }

  before do
    sign_in user
    visit "/brackets/#{bracket.id}"
  end

  it "fills in the bracket with the user's picks" do
    champ_name = bracket.tree.championship.team.name
    expect(champ_name).to be_present

    expect(page).to have_css(".champion-box", text: champ_name)
  end
end
