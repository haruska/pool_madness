require "rails_helper"

RSpec.describe Queries::ChargeType do
  subject { Queries::ChargeType }

  context "fields" do
    let(:fields) { %w[id stripe_id amount description] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
