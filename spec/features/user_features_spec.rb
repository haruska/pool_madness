require "spec_helper"

describe "User creation, authentication, deletion", type: :feature, js: true do
  # describe "Signing up" do
  #   let(:email) { Faker::Internet.email }
  #   let(:password) { Faker::Internet.password }
  #
  #   before { visit new_user_registration_path }
  #
  #   it "allows you to signup with an email address and password" do
  #     fill_in "user[email]", with: email
  #     fill_in :user_password, with: password
  #     fill_in :user_password_confirmation, with: password
  #
  #     click_button "Sign up"
  #     expect(page).to have_link("Sign Out")
  #     expect(User.find_by(email: email)).to be_present
  #   end
  #
  #   it "requires an email address" do
  #     click_button "Sign up"
  #     expect(page).to have_content("can't be blank")
  #   end
  #
  #   context "verification" do
  #     before do
  #       fill_in :user_email, with: email
  #       fill_in :user_password, with: password
  #       fill_in :user_password_confirmation, with: password
  #
  #       click_button "Sign up"
  #     end
  #
  #     it "sends an email to verify the users email address" do
  #       expect(ActionMailer::Base.deliveries.last.to.first).to eq(email)
  #     end
  #   end
  # end
  #
  describe "Signing in" do
    let!(:pool) { create(:pool) }
    let(:password) { Faker::Internet.password }
    subject { create(:user, password: password, password_confirmation: password) }

    before { visit new_user_session_path }

    it "allows you to login with a email address and password" do
      fill_in "user[email]", with: subject.email
      fill_in "user[password]", with: password
      click_button "Sign in"
      expect(page).to have_content("Signed in successfully")
    end
  end
  #
  # describe "password recovery" do
  #   subject { FactoryGirl.create(:user) }
  #
  #   before do
  #     visit new_user_session_path
  #     click_link "Forgot your password?"
  #   end
  #
  #   it "emails password reset instructions" do
  #     fill_in "user[email]", with: subject.email
  #     click_button "Reset Password"
  #
  #     expect(ActionMailer::Base.deliveries.last.to.first).to eq(subject.email)
  #   end
  # end
  #
  # describe "Viewing profile" do
  #   let(:user) { create(:user) }
  #
  #   before do
  #     sign_in user
  #     visit user_path
  #   end
  #
  #   it "displays the user's profile information" do
  #     expect(page).to have_content(user.first_name)
  #     expect(page).to have_content(user.last_name)
  #     expect(page).to have_content(user.email)
  #   end
  #
  #   it "has an edit link" do
  #     expect(page).to have_link("Edit Profile", href: edit_user_path)
  #   end
  #
  #   describe "My account sidebar" do
  #     it "has links to account pages" do
  #       within ".sidebar" do
  #         expect(page).to have_link("Change Password", href: edit_user_registration_path)
  #         expect(page).to have_link("Profile", href: user_path)
  #       end
  #     end
  #   end
  # end
end
