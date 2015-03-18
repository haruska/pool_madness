require "spec_helper"

describe PossibleOutcome, type: :model do
  before(:all) {
    @tournament = create(:tournament, :with_first_two_rounds_completed)
    @pool = create(:pool, tournament: @tournament)
    @possible_outcome_set = create(:possible_outcome_set, pool: @pool)
    @brackets = create_list(:bracket, 5, :completed, pool: @pool)
    @all_slot_bits = @possible_outcome_set.all_slot_bits
    @possible_outcome = @possible_outcome_set.generate_outcome(@all_slot_bits.sample)
  }

  let(:tournament) { @tournament }
  let(:pool) { @pool }
  let(:brackets) { @brackets }
  let(:all_slot_bits) { @all_slot_bits }
  subject { @possible_outcome }


  describe "#create_possible_game" do
    let!(:slot_bits) { all_slot_bits.sample }
    let!(:game) { subject.possible_games.values.sample.game }
    let!(:score_one) { subject.possible_games[game.id].score_one }
    let!(:score_two) { subject.possible_games[game.id].score_two }

    let(:possible_game) { subject.create_possible_game(game: game, score_one: score_one, score_two: score_two) }

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
    let(:sorted_brackets) { subject.sorted_brackets }

    it "calculates the points possible for all brackets" do
      brackets.each do |bracket|
        expected_points = bracket.picks.map do |pick|
          possible_games[pick.game_id].points_for_pick(pick.team_id)
        end.sum

        result_pair = sorted_brackets.find {|b, _p| b == bracket }
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

  describe "#update_brackets_best_possible" do
    let(:sorted_brackets) { subject.sorted_brackets }
    let(:third_place_index) do
      t_index = 2
      third_place_points = sorted_brackets[t_index][1]
      while sorted_brackets[t_index + 1][1] == third_place_points
        t_index += 1
      end
      t_index
    end

    let(:bracket_groups) do
      place_points = sorted_brackets[0..2].map(&:last)
      place_points[1] = nil if place_points[1] == place_points[0]
      place_points[2] = nil if place_points[2] == place_points[1]

      place_points.map do |pp|
        sorted_brackets.select {|_, points| pp == points }.map(&:first)
      end
    end

    it "updates the first/second/third brackets" do
      subject.update_brackets_best_possible

      bracket_groups.each_with_index do |brackets, i|
        brackets.each do |bracket|
          expect(bracket.best_possible).to eq(i)
        end
      end
    end

    context "with a tie for third" do
      before do
        sorted_brackets[3][1] = sorted_brackets[2][1]
        expect(subject).to receive(:sorted_brackets).and_return(sorted_brackets)
      end

      it "updates the first/second/third brackets" do
        subject.update_brackets_best_possible

        bracket_groups.each_with_index do |brackets, i|
          brackets.each do |bracket|
            expect(bracket.best_possible).to eq(i)
          end
        end
      end
    end

    context "when a lesser place than current for the bracket" do
      let(:first_brackets) { bracket_groups[1] + bracket_groups[2] }

      before do
        first_brackets.each do |bracket|
          bracket.bracket_point.best_possible = 0
          bracket.bracket_point.save!
        end
      end

      it "keeps the higher possible place" do
        subject.update_brackets_best_possible
        first_brackets.each do |bracket|
          expect(bracket.bracket_point.reload.best_possible).to eq(0)
        end
      end
    end
  end
end
