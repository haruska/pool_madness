require "rails_helper"

RSpec.describe Queries::TeamType do
  subject { Queries::TeamType }

  context "fields" do
    let(:fields) { %w(id model_id name seed still_playing) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
