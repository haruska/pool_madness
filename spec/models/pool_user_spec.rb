require "rails_helper"

RSpec.describe PoolUser, type: :model do
  subject { create(:pool_user) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:pool) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:pool) }
  it { is_expected.to validate_uniqueness_of(:user).scoped_to(:pool_id) }

  describe "roles" do
    it "defaults to regular" do
      expect(subject).to be_regular
    end

    context "an admin" do
      before { subject.admin! }

      it "is a pool administrator" do
        expect(subject).to be_admin
      end
    end
  end
end
