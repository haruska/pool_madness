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
      expect(page).to have_link("Edit Profile", href: edit_profile_path)
      expect(page).to have_link("Change Password", href: edit_user_registration_path)
    end
  end
end
