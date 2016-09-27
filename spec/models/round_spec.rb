require "rails_helper"

RSpec.describe Round do
  subject { build(:round) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tournament) }
    it { is_expected.to validate_presence_of(:number) }
  end
end
