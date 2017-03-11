require "rails_helper"

RSpec.describe "Using invite codes", js: true do
  context "a new user" do
    let(:full_name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password }
    let(:pool) { create(:pool, tournament: create(:tournament, :not_started)) }

    before do
      visit "/"
      find("#content").click_link "Sign Up"
      fill_in "user_name", with: full_name
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password
      click_button "Sign Up"
      expect(page).to have_text(/any tournament pools/i)
    end

    context "with a valid invite code" do
      it "joins the user to the pool and shows a list of pools" do
        first("a.button").click
        fill_in "invite_code", with: pool.invite_code
        click_button "Join Pool"
        expect(page).to have_css(".name", text: pool.name)
      end
    end

    context "with an invalid invite code" do
      it "shows an error" do
        first("a.button").click
        fill_in "invite_code", with: "invalidcode"
        click_button "Join Pool"
        # expect(page).to have_text(/Invalid code entered/i)
        expect(page).to have_field("invite_code")
      end
    end
  end
end
