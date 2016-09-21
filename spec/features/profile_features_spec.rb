require "rails_helper"

RSpec.describe "User Profiles", js: true do
  describe "My Profile" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit "/user"
    end

    it "is the current user's profile" do
      expect(page).to have_css(".title", text: "Profile")
      expect(page).to have_css(".name", text: user.name)
      expect(page).to have_css(".email", text: user.email)
    end

    it "has edit profile and change password actions" do
      expect(page).to have_link("Edit Profile", href: "/user/edit")
      expect(page).to have_link("Change Password", href: edit_user_registration_path)
    end
  end

  describe "Editing a Profile" do
    let(:user) { create(:user) }
    let(:new_name) { Faker::Name.name }
    let(:new_email) { Faker::Internet.email }

    before do
      sign_in user
      visit "/user"
      click_link "Edit Profile"

      expect(page).to have_css(".title", text: "Edit Profile")

      fill_in "user[name]", with: new_name
      fill_in "user[email]", with: new_email
    end

    context "with valid data" do
      it "updates the user info" do
        click_button "Update"

        expect(page).to have_css(".title", text: "Profile")
        expect(page).to have_css(".name", text: new_name)
        expect(page).to have_css(".email", text: new_email)
      end
    end

    context "and canceling" do
      it "discards any updates" do
        click_link "Cancel"

        expect(page).to have_css(".title", text: "Profile")
        expect(page).to have_css(".name", text: user.name)
        expect(page).to have_css(".email", text: user.email)
      end
    end
  end
end
