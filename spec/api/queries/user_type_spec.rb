require "rails_helper"

RSpec.describe Queries::UserType do
  subject { Queries::UserType }

  context "fields" do
    let(:fields) { %w(id model_id name) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
