require "rails_helper"

RSpec.describe Queries::BracketType do
  subject { Queries::BracketType }

  context "fields" do
    let(:fields) { %w(id model_id name tie_breaker status points possible_points best_possible_finish final_four) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end

    describe "model_id" do
      subject { Queries::BracketType.fields["model_id"] }

      let!(:bracket) { create(:bracket) }

      it "is the DB id of the object" do
        expect(subject.resolve(bracket, nil, nil)).to eq(bracket.id)
      end
    end
  end

  describe "final_four" do
    subject { Queries::BracketType.fields["final_four"] }

    let!(:bracket) { create(:bracket, :completed) }
    let(:resolved_obj) { subject.resolve(bracket, nil, nil).object }

    it "is a list of the final four teams for the bracket" do
      expect(resolved_obj).to eq(bracket.sorted_four)
    end
  end
end
