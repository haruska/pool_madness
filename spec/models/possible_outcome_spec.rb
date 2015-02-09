require "spec_helper"

describe PossibleOutcome, type: :model do
  before { build(:tournament, :with_first_two_rounds_completed) }
  let!(:brackets) { create_list(:bracket, 5) }

  describe "#generate_cached_opts" do
    let!(:cached_opts) { PossibleOutcome.generate_cached_opts }

    it "gathers all games in slot_bit order" do
      expect(cached_opts[:games]).to eq(Game.already_played.order(:id).to_a + Game.not_played.order(:id).to_a)
    end

    it "gathers all brackets and caches the associated picks" do
      brackets.each do |bracket|
        expect(cached_opts[:brackets]).to include(bracket)
      end
    end

    it "gathers all team objects in a hash" do
      Team.all.each do |team|
        expect(cached_opts[:teams][team.id]).to eq(team)
      end
    end
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
