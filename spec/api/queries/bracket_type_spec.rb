require "rails_helper"

RSpec.describe Queries::BracketType do
  subject { Queries::BracketType }

  context "fields" do
    let(:fields) { %w(id model_id name owner pool editable tie_breaker status points possible_points best_possible_finish eliminated final_four game_decisions game_mask) }

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

  describe "best_possible_finish" do
    subject { Queries::BracketType.fields["best_possible_finish"] }
    let(:bracket) { create(:bracket) }
    let(:bracket_point) { bracket.bracket_point }

    let(:resolved) { subject.resolve(bracket, nil, nil) }

    context "1st place" do
      before { bracket_point.update(best_possible: 0) }

      it "is '1st'" do
        expect(resolved).to eq("1st")
      end
    end

    context "2nd place" do
      before { bracket_point.update(best_possible: 1) }

      it "is '2nd'" do
        expect(resolved).to eq("2nd")
      end
    end

    context "3rd place" do
      before { bracket_point.update(best_possible: 2) }

      it "is '3rd'" do
        expect(resolved).to eq("3rd")
      end
    end

    context "eliminated" do
      before { bracket_point.update(best_possible: 3) }

      it "is '-'" do
        expect(resolved).to eq("-")
      end
    end
  end

  describe "eliminated" do
    subject { Queries::BracketType.fields["eliminated"] }
    let(:bracket) { create(:bracket) }
    let(:bracket_point) { bracket.bracket_point }

    let(:resolved) { subject.resolve(bracket, nil, nil) }

    context "is not eliminated" do
      before { bracket_point.update(best_possible: 0) }

      it "is false" do
        expect(resolved).to eq(false)
      end
    end

    context "is eliminated" do
      before { bracket_point.update(best_possible: 3) }

      it "is false" do
        expect(resolved).to eq(true)
      end
    end
  end

  describe "final_four" do
    subject { Queries::BracketType.fields["final_four"] }

    let!(:bracket) { create(:bracket, :completed) }
    let(:resolved) { subject.resolve(bracket, nil, nil) }

    it "is a list of the final four teams for the bracket" do
      expect(resolved).to eq(bracket.sorted_four)
    end
  end

  describe "editable" do
    subject { Queries::BracketType.fields["editable"] }
    let!(:bracket) { create(:bracket) }
    let(:context) { { current_user: user, current_ability: Ability.new(user) } }
    let(:resolved) { subject.resolve(bracket, nil, context) }

    context "not logged in" do
      let(:user) { nil }

      it "is not editable" do
        expect(resolved).to eq(false)
      end
    end

    context "as someone who cannot edit the bracket" do
      let(:user) { create(:user) }

      it "is not editable" do
        expect(resolved).to eq(false)
      end
    end

    context "as someone who can edit the bracket" do
      let(:user) { create(:admin_user) }

      it "is editable" do
        expect(resolved).to eq(true)
      end
    end
  end

  context "bitmasks" do
    let(:bracket) { create(:bracket, :completed) }
    let(:context) { { current_user: bracket.user, current_ability: Ability.new(bracket.user) } }
    let(:resolved) { subject.resolve(bracket, nil, context) }

    describe "game_decisions" do
      subject { Queries::BracketType.fields["game_decisions"] }

      it "is a string of zeros and ones representing the bracket decisions" do
        expect(resolved).to eq(Array.new(2**bracket.tournament.num_rounds) { |i| (bracket.tree_decisions & (1 << i)).zero? ? "0" : "1" }.join)
      end
    end

    describe "game_mask" do
      subject { Queries::BracketType.fields["game_mask"] }

      it "is a string of zeros and ones representing the bracket bitmask" do
        expect(resolved).to eq(Array.new(2**bracket.tournament.num_rounds) { |i| (bracket.tree_mask & (1 << i)).zero? ? "0" : "1" }.join)
      end
    end
  end
end
