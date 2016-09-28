require "rails_helper"

RSpec.describe Queries::RoundType do
  subject { Queries::RoundType }
  let(:round) { build(:round) }

  context "fields" do
    let(:fields) { %w(id name number start_date end_date games) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end

  describe "start_date" do
    subject { Queries::RoundType.fields["start_date"] }

    it "is an iso 8601 string representing the round start date" do
      expect(subject.resolve(round, nil, nil)).to eq(round.start_date.iso8601)
    end
  end

  describe "end_date" do
    subject { Queries::RoundType.fields["end_date"] }

    it "is an iso 8601 string representing the round end date" do
      expect(subject.resolve(round, nil, nil)).to eq(round.end_date.iso8601)
    end
  end
end
