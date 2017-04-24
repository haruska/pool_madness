require "rails_helper"
require "stripe_mock"

RSpec.describe User, type: :model do
  subject! { create(:user) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(8) }

  it { is_expected.to have_many(:brackets) }
  it { is_expected.to have_many(:brackets_to_pay) }
  it { is_expected.to have_many(:pool_users) }
  it { is_expected.to have_many(:pools).through(:pool_users) }

  it { is_expected.to allow_value("user@foo.com").for(:email) }
  it { is_expected.to allow_value("THE_USER@foo.bar.org").for(:email) }
  it { is_expected.to allow_value("first.last@foo.jp").for(:email) }

  it { is_expected.to_not allow_value("user@foo,com").for(:email) }
  it { is_expected.to_not allow_value("user_at_foo.org").for(:email) }
  it { is_expected.to_not allow_value("example.user@foo.").for(:email) }

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
      before { subject.update(stripe_customer_id: stripe_customer.id) }

      it "reuses the same stripe customer" do
        expect(User.find_by(email: subject.email).stripe_customer.id).to eq(stripe_customer.id)
      end
    end
  end

  describe "#accept_invitation!" do
    let(:queue) { ActiveJob::Base.queue_adapter.enqueued_jobs }

    it "sends a welcome message" do
      expect { subject.accept_invitation! }.to change(queue, :size).by(1)
      expect(queue.last[:args].second).to eq("welcome_message")
    end
  end

  describe "roles" do
    it "defaults to a regular user" do
      expect(subject).to be_regular
    end

    context "an admin" do
      before { subject.admin! }

      it "is an admin" do
        expect(subject).to be_admin
      end
    end
  end
end
