require 'spec_helper'

RSpec.describe Round, type: :model do
  subject { build(:round) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tournament) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:tournament_id) }
    it { is_expected.to validate_uniqueness_of(:number).scoped_to(:tournament_id) }
  end
end
