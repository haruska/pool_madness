require "spec_helper"

describe PossibleOutcomeSet, type: :model do
  before(:all) {
    @tournament = create(:tournament, :with_first_two_rounds_completed)
    @pool = create(:pool, tournament: @tournament)
    @brackets = create_list(:bracket, 5, :completed, pool: @pool)
  }

  let(:tournament) { @tournament }
  let(:pool) { @pool }
  let(:brackets) { @brackets }

  subject { PossibleOutcomeSet.new(tournament: tournament) }


  context "slot_bit_calculation" do


    let(:already_played_games) { subject.already_played_games }
    let(:to_play_games) { subject.not_played_games }

    let(:to_play_mask) do
      mask = 0
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
      winners_mask
    end

    describe "#min_slot_bits" do
      it "is the already played mask shifted by the number of not played games" do
        expect(subject.min_slot_bits).to eq(already_played_mask << to_play_games.size)
      end
    end

    describe "#max_slot_bits" do
      it "is min_slot_bits with the to_play_games bits at 1" do
        expect(subject.max_slot_bits).to eq(subject.min_slot_bits | to_play_mask)
      end
    end
  end

  describe "#update_outcome" do
    let(:slot_bits) { Faker::Number.between(subject.min_slot_bits, subject.max_slot_bits) }

    it "creates a possible game for each game in the tournament" do
      outcome = subject.update_outcome(slot_bits)

      result_games = outcome.possible_games.values.map(&:game)
      tournament.games.each { |game| expect(result_games).to include(game) }
    end

    it "updates the cached possible outcome" do
      expect(subject.update_outcome(slot_bits).object_id).to eq(subject.possible_outcome.object_id)
    end
  end
end
