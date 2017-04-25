require "rails_helper"

RSpec.describe Types::PossibilityType do
  subject { Types::PossibilityType }

  context "fields" do
    let(:fields) { %w[championships first_place second_place third_place] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
