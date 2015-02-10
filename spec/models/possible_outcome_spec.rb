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
    let(:all_slot_bits) { PossibleOutcome.generate_all_slot_bits }
    let(:already_played_games) { Game.already_played.all }
    let(:to_play_games) { Game.not_played }
    let(:to_play_mask) do
      mask = 1
      to_play_games.size.times { |i| mask |= 1 << i }
      mask
    end

    let(:already_played_mask) do
      winners_mask = 0
      already_played_games.each_with_index do |game, i|
        slot_index = already_played_games.size - i - 1
        if game.score_one < game.score_two
          winners_mask |= 1 << slot_index
        end
      end
      winners_mask << to_play_games.size
    end

    it "iterates on bits of remaining games" do
      (0..to_play_mask).each do |i|
        expect(all_slot_bits).to include((already_played_mask | i))
      end
    end

    it "keeps already played games mask constant" do
      all_slot_bits.each do |slot_bits|
        expect((slot_bits & already_played_mask).to_s(16)).to eq(already_played_mask.to_s(16))
      end
    end

    context "with a block" do
      it "is nil" do
        expect(PossibleOutcome.generate_all_slot_bits {|_| }).to be_nil
      end

      it "yields individual slot_bits" do
        PossibleOutcome.generate_all_slot_bits do |slot_bits|
          expect(all_slot_bits).to include(slot_bits)
        end
      end
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
