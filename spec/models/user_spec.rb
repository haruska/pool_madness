require "spec_helper"

describe User, type: :model do
  subject! { create(:user) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(8) }

  it { should allow_value("user@foo.com").for(:email) }
  it { should allow_value("THE_USER@foo.bar.org").for(:email) }
  it { should allow_value("first.last@foo.jp").for(:email) }

  it { should_not allow_value("user@foo,com").for(:email) }
  it { should_not allow_value("user_at_foo.org").for(:email) }
  it { should_not allow_value("example.user@foo.").for(:email) }

  describe "#stripe_customer" do
    before { StripeMock.start }
    after { StripeMock.stop }

    context "with no previous stripe id" do
      it "creates a new stripe customer" do
        expect(subject.stripe_customer_id).to be_nil

        stripe_customer = subject.stripe_customer

        expect(stripe_customer.email).to eq(subject.email)

        expect(subject.stripe_customer_id).to eq(stripe_customer.id)
      end
    end

    context "with a previous stripe id" do
      let(:stripe_customer) { Stripe::Customer.create(email: subject.email) }
      before { subject.update_attribute(:stripe_customer_id, stripe_customer.id) }

      it "reuses the same stripe customer" do
        expect(User.find_by(email: subject.email).stripe_customer.id).to eq(stripe_customer.id)
      end
    end
  end

  describe "#accept_invitation!" do
    before { ActionMailer::Base.deliveries = []  }

    it "sends a welcome message" do
      subject.accept_invitation!
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end
  end
end
