require "spec_helper"

describe PossibleOutcomeSet, type: :model do
  before(:all) {
    @tournament = create(:tournament, :with_first_two_rounds_completed)
    @pool = create(:pool, tournament: @tournament)
    @possible_outcome_set = create(:possible_outcome_set, pool: @pool)
    @brackets = create_list(:bracket, 5, :completed, pool: @pool)
    @all_slot_bits = @possible_outcome_set.all_slot_bits
  }

  let(:tournament) { @tournament }
  let(:pool) { @pool }
  let(:brackets) { @brackets }
  let(:all_slot_bits) { @all_slot_bits }
  subject { @possible_outcome_set }


  describe "#all_slot_bits" do
    let(:already_played_games) { subject.already_played_games }
    let(:to_play_games) { subject.not_played_games }
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
        expect(subject.all_slot_bits {|_| }).to be_nil
      end

      it "yields individual slot_bits" do
        subject.all_slot_bits do |slot_bits|
          expect(all_slot_bits).to include(slot_bits)
        end
      end
    end
  end

  describe "#generate_outcome" do
    let(:slot_bits) { all_slot_bits.sample }
    let(:generated_outcome) { subject.generate_outcome(slot_bits) }

    it "creates a possible game for each game in the tournament" do
      result_games = generated_outcome.possible_games.values.map(&:game)
      tournament.games.each { |game| expect(result_games).to include(game) }
    end
  end
end
