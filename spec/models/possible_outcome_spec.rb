require "spec_helper"

describe PossibleOutcome, type: :model do
  before(:all) {
    @tournament = create(:tournament, :with_first_two_rounds_completed)
    @pool = create(:pool, tournament: @tournament)
    @possible_outcome = create(:possible_outcome, pool: @pool)
    @brackets = create_list(:bracket, 5, :completed, pool: @pool)
    @all_slot_bits = @possible_outcome.generate_all_slot_bits
  }

  let(:tournament) { @tournament }
  let(:pool) { @pool }
  let(:brackets) { @brackets }
  let(:all_slot_bits) { @all_slot_bits }
  subject { @possible_outcome }


  describe "#generate_cached_opts" do
    let!(:cached_opts) { subject.generate_cached_opts }

    it "gathers all games in slot_bit order" do
      expect(cached_opts[:games]).to eq(tournament.games.already_played.order(:id).to_a + tournament.games.not_played.order(:id).to_a)
    end

    it "gathers all brackets and caches the associated picks" do
      brackets.each do |bracket|
        expect(cached_opts[:brackets]).to include(bracket)
      end
    end

    it "gathers all team objects in a hash" do
      tournament.teams.each do |team|
        expect(cached_opts[:teams][team.id]).to eq(team)
      end
    end
  end

  describe "#generate_all_slot_bits" do
    let(:already_played_games) { tournament.games.already_played }
    let(:to_play_games) { tournament.games.not_played }
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
        expect(subject.generate_all_slot_bits {|_| }).to be_nil
      end

      it "yields individual slot_bits" do
        subject.generate_all_slot_bits do |slot_bits|
          expect(all_slot_bits).to include(slot_bits)
        end
      end
    end
  end

  describe "#generate_outcome" do
    let(:slot_bits) { all_slot_bits.sample }

    context "with cached options passed in" do
      let(:cached_opts) { subject.generate_cached_opts }
      let(:generated_outcome) { subject.generate_outcome(slot_bits, cached_opts) }

      it "uses the games from options" do
        cached_opts[:games].each do |game|
          expect(generated_outcome.possible_games[game.id].game).to eq(game)
        end
      end

      it "uses the passed in brackets" do
        expect(generated_outcome.brackets).to eq(cached_opts[:brackets])
      end

      it "uses the passed in teams" do
        expect(generated_outcome.teams).to eq(cached_opts[:teams])
      end
    end

    context "with no cached options passed in" do
      let(:generated_outcome) { subject.generate_outcome(slot_bits) }

      it "gathers all games in slot_bit order" do
        Game.all.each do |game|
          expect(generated_outcome.possible_games[game.id].game).to eq(game)
        end
      end

      it "gathers all brackets" do
        expect(generated_outcome.brackets).to eq(pool.brackets.includes(:picks).to_a)
      end

      it "gathers all teams" do
        expect(generated_outcome.teams).to eq(tournament.teams.each_with_object(Hash.new) {|team, acc| acc[team.id] = team})
      end
    end
  end

  describe "#create_possible_game" do
    let(:slot_bits) { all_slot_bits.sample }
    let(:cached_opts) { subject.generate_cached_opts }
    let(:brackets) { cached_opts[:brackets] }
    let(:teams) { cached_opts[:teams] }
    let(:game) { cached_opts[:games].sample }

    subject { PossibleOutcome.new(slot_bits: slot_bits, brackets: brackets, teams: teams, pool: pool) }

    let!(:possible_game) { subject.create_possible_game(game: game, score_one: 1, score_two: 2) }

    it "creates a new possible game given the game hash" do
      expect(possible_game.game).to eq(game)
      expect(possible_game.score_one).to eq(1)
      expect(possible_game.score_two).to eq(2)
    end

    it "sets the possible outcome to itself" do
      expect(possible_game.possible_outcome).to eq(subject)
    end

    it "adds the possible game to the possible_games hash" do
      expect(subject.possible_games[game.id]).to eq(possible_game)
    end
  end

  describe "#championship" do
    let(:championship) { Game.championship }
    subject { subject.generate_outcome(0) }

    it "returns the championship possible game" do
      expect(subject.championship).to be_a(PossibleGame)
      expect(subject.championship.game).to eq(championship)
    end
  end

  describe "#round_for" do
    subject { subject.generate_outcome(0) }

    it "behaves as Game.round_for and is a set of PossibleGames from this outcome" do
      Team::REGIONS.each do |region|
        (1..6).each do |round_number|
          games = Game.round_for(round_number, region)
          possible_games = subject.round_for(round_number, region)

          expect(possible_games.map(&:game)).to match_array(games)
        end
      end
    end
  end

  describe "#sorted_brackets" do
    let(:slot_bits) { subject.generate_all_slot_bits.sample }
    subject { subject.generate_outcome(slot_bits) }
    let(:possible_games) { subject.possible_games }
    let(:sorted_brackets) { subject.sorted_brackets }

    it "calculates the points possible for all brackets" do
      Bracket.all.each do |bracket|
        expected_points = bracket.picks.map do |pick|
          possible_games[pick.game_id].points_for_pick(pick.team_id)
        end.sum

        result_pair = sorted_brackets.find {|b, p| b == bracket }
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
    let(:slot_bits) { subject.generate_all_slot_bits.sample }
    subject { subject.generate_outcome(slot_bits) }
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
          bracket.best_possible = 0
          bracket.save!
        end
      end

      it "keeps the higher possible place" do
        subject.update_brackets_best_possible
        first_brackets.each do |bracket|
          expect(bracket.best_possible).to eq(0)
        end
      end
    end
  end
end
