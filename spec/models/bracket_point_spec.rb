require "rails_helper"

RSpec.describe BracketPoint, type: :model do
  before(:all) { @tournament = create(:tournament, :completed) }

  let(:tournament) { @tournament }
  let(:pool) { create(:pool, tournament: tournament) }

  subject { create(:bracket, :completed, pool: pool).bracket_point }

  describe "#calculate_points" do
    let(:expected_sum) { (1..tournament.num_games).map {|slot| subject.bracket.tree.at(slot).points }.sum}

    it "is the sum of all the picks' points" do
      expect(subject.calculate_points).to eq(expected_sum)
    end

    it "updates the #points attribute" do
      expected_points = subject.calculate_points
      expect(subject.points).to eq(expected_points)
    end
  end

  describe "#calculate_possible_points" do
    let(:expected_sum) { (1..tournament.num_games).map {|slot| subject.bracket.tree.at(slot).possible_points }.sum}

    it "is the sum of all picks' possible points" do
      expect(subject.calculate_possible_points).to eq(expected_sum)
    end

    it "updates the #possible_points attribute" do
      expected_points = subject.calculate_possible_points
      expect(subject.possible_points).to eq(expected_points)
    end
  end
end
