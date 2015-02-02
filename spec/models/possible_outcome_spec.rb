require "spec_helper"

describe PossibleOutcome, type: :model do
  before(:all) { build(:tournament) }
  let!(:brackets) { create_list(:bracket, 5) }

  context "round and two completed" do
    before do
      (1..2).each do |round|
        Team::REGIONS.each do |region|
          Game.round_for(round, region).each do |game|
            while game.score_one.nil? || game.score_one == game.score_two
              game.update_attributes(score_one: rand(100), score_two: rand(100))
            end
          end
        end
      end
    end

    describe "#generate_cached_opts" do
      let!(:cached_opts) { PossibleOutcome.generate_cached_opts }

      it "gathers all games in slot_bit order" do

      end
      it "gathers all brackets and caches the associated picks"
      it "gathers all team objects in a hash"
    end

    describe "#generate_all_slot_bits" do
      it "iterates on bits of remaining games"
      it "keeps already played games mask constant"

      context "with a block" do
        it "is nil"
        it "yields individual slot_bits"
      end

      context "without a block" do
        it "is all collected slot bits"
      end
    end

    describe "#generate_outcome" do
      context "with cached options passed in" do
        it "uses the games from options"
        it "uses the passed in brackets"
        it "uses the passed in teams"
      end

      context "with no cached options passed in" do
        it "gathers all games in slot_bit order"
        it "gathers all brackets"
        it "gathers all teams"
      end

      it "generates all possible games given the slot bits"
    end

    describe "#create_possible_game" do
      it "creates a new possible game given the game hash"
      it "sets the possible outcome to itself"
      it "adds the possible game to the possible_games hash"
    end

    describe "#championship" do
      it "returns the championship possible game"
    end

    describe "#round_for" do
      it "behaves as Game.round_for"
      it "is a set of PossibleGames from this outcome"
    end

    describe "#update_brackets_best_possible" do
      it "updates the first/second/third brackets"
      it "allows for multiple third places on ties and updates all"

      context "when a lesser place than current for the bracket" do
        it "keeps the higher possible place"
      end
    end

    describe "#sorted_brackets" do
      it "calculates the points possible for all brackets"
      it "is an array of pairs of brackets, points"
    end
  end
end
