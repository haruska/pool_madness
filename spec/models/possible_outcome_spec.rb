require "spec_helper"

describe PossibleOutcome, type: :model do
  before(:all) do
    @tournament = create(:tournament, :with_first_two_rounds_completed)
    @pool = create(:pool, tournament: @tournament)
    @brackets = create_list(:bracket, 5, :completed, pool: @pool)
  end

  let(:tournament) { @tournament }
  let(:pool) { @pool }
  let(:brackets) { @brackets }
  let(:possible_outcome_set) { PossibleOutcomeSet.new(tournament: tournament) }
  let(:slot_bits) { Faker::Number.between(possible_outcome_set.min_slot_bits, possible_outcome_set.max_slot_bits) }

  subject { possible_outcome_set.update_outcome(slot_bits) }

  describe "#create_or_update_possible_game" do
    let!(:game) { subject.possible_games.values.sample.game }
    let!(:score_one) { subject.possible_games[game.id].score_one }
    let!(:score_two) { subject.possible_games[game.id].score_two }

    let(:possible_game) { subject.create_or_update_possible_game(game: game, score_one: score_one, score_two: score_two) }

    it "creates a new possible game given the game hash" do
      expect(possible_game.game).to eq(game)
      expect(possible_game.score_one).to eq(score_one)
      expect(possible_game.score_two).to eq(score_two)
    end

    it "sets the possible outcome to itself" do
      expect(possible_game.possible_outcome).to eq(subject)
    end

    it "adds the possible game to the possible_games hash" do
      expect(subject.possible_games[game.id]).to eq(possible_game)
    end
  end

  describe "#championship" do
    let(:championship) { tournament.championship }

    it "returns the championship possible game" do
      expect(subject.championship).to be_a(PossibleGame)
      expect(subject.championship.game).to eq(championship)
    end
  end

  describe "#round_for" do
    it "behaves as Tournament.round_for and is a set of PossibleGames from this outcome" do
      Team::REGIONS.each do |region|
        (1..6).each do |round_number|
          games = tournament.round_for(round_number, region)
          possible_games = subject.round_for(round_number, region)

          expect(possible_games.map(&:game)).to match_array(games)
        end
      end
    end
  end

  describe "#sorted_brackets" do
    let(:possible_games) { subject.possible_games }
    let(:sorted_brackets) { subject.sorted_brackets(pool) }

    it "calculates the points possible for all brackets" do
      brackets.each do |bracket|
        expected_points = bracket.picks.map do |pick|
          possible_games[pick.game_id].points_for_pick(pick.team_id)
        end.sum

        result_pair = sorted_brackets.find { |b, _p| b == bracket }
        expect(result_pair.last).to eq(expected_points)
      end
    end

    it "is a sorted array of pairs of brackets, points" do
      sorted_brackets.map(&:first).each do |b|
        expect(b).to be_a(Bracket)
      end

      expect(sorted_brackets.map(&:last)).to eq(sorted_brackets.map(&:last).sort.reverse)
    end
  end

  describe "#get_best_possible" do
    let(:sorted_brackets) { subject.sorted_brackets(pool) }

    let(:third_place_index) do
      t_index = 2
      third_place_points = sorted_brackets[t_index][1]
      t_index += 1 while sorted_brackets[t_index + 1][1] == third_place_points
      t_index
    end

    let(:expected) do
      sorted_brackets[0..third_place_index].map do |bracket, points|
        [bracket, sorted_brackets.index { |_b, p| p == points }]
      end
    end

    it "is the first/second/third brackets" do
      expect(subject.get_best_possible(pool)).to eq(expected)
    end

    context "with a tie for third" do
      before do
        sorted_brackets[3][1] = sorted_brackets[2][1]
        expect(subject).to receive(:sorted_brackets).with(pool).and_return(sorted_brackets)
      end

      it "includes both brackets in the tie" do
        best_brackets = subject.get_best_possible(pool).map(&:first)

        sorted_brackets[2..3].map(&:first).each do |bracket|
          expect(best_brackets).to include(bracket)
        end
      end
    end
  end
end
