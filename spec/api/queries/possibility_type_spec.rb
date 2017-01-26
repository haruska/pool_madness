require "rails_helper"

RSpec.describe Queries::PossibilityType do
  subject { Queries::PossibilityType }

  context "fields" do
    let(:fields) { %w(championships first_place second_place third_place) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
