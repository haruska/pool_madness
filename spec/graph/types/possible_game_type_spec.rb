require "rails_helper"

RSpec.describe Types::PossibleGameType do
  subject { Types::PossibleGameType }

  context "fields" do
    let(:fields) { %w[slot previous_slot_one previous_slot_two next_game_slot next_game_position first_team second_team winning_team losing_team round_number region] }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end
  end
end
