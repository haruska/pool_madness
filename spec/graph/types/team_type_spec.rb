require "rails_helper"

RSpec.describe Types::TeamType do
  subject { Types::TeamType }

  context "fields" do
    let(:fields) { %w[id model_id name seed starting_slot] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
