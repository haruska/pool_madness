require "rails_helper"

RSpec.describe "Menu", js: true do
  describe "Logout" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit("/")
    end

    it "logs the user out of the system" do
      find(".fa-bars").click
      click_link "Logout"

      expect(page).to have_text(/private pool/i)
      find(".fa-bars").click
      expect(page).to have_link("Login")
    end
  end
end
