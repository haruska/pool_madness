require "rails_helper"

RSpec.describe Queries::TeamType do
  subject { Queries::TeamType }

  context "fields" do
    let(:fields) { %w(id name) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
