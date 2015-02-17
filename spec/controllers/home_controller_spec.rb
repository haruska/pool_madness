require "spec_helper"

describe HomeController, type: :controller do
  describe "#index" do
    it "should be successful" do
      get :index
      expect(response).to be_success
    end
  end

  describe "#subscribe" do
    let(:email) { Faker::Internet.email }
    before { ActionMailer::Base.deliveries = [] }

    it "emails a newsletter to the subscriber" do
      post :subscribe, email: email
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "redirects to root path with a thank you notice" do
      post :subscribe, email: email
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to be_present
    end
  end

  describe "#rules" do
    context "when not logged in" do
      it "redirects to root path" do
        get :rules
        expect(response).to redirect_to(root_path)
      end
    end
    context "when logged in" do
      let(:user) { create(:user) }
      before { sign_in(user) }

      it "shows the rules" do
        get :rules
        expect(response).to be_success
      end
    end
  end

  describe "#payments" do
    context "when not logged in" do
      it "redirects to root path" do
        get :payments
        expect(response).to redirect_to(root_path)
      end
    end
    context "when logged in" do
      let(:user) { create(:user) }
      before { sign_in(user) }

      it "shows the payment options" do
        get :payments
        expect(response).to be_success
      end
    end
  end
end
