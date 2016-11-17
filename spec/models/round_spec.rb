require "rails_helper"

RSpec.describe Round do
  subject { build(:round) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:tournament) }
    it { is_expected.to validate_presence_of(:number) }
  end

  describe "graph ids" do
    it "incorporates the tournament id and round number" do
      expect(subject.id).to eq("#{subject.tournament.id}~#{subject.number}")
    end

    it "can be used to reconstruct the round" do
      round = Round.find(subject.id)
      expect(round.tournament).to eq(subject.tournament)
      expect(round.number).to eq(subject.number)
    end
  end

  describe "regions" do
    let(:tournament) { create(:tournament) }

    context "earlier rounds" do
      let(:rounds) do
        (1..(tournament.num_rounds - 2)).to_a.map do |i|
          build(:round, tournament: tournament, number: i)
        end
      end

      it "is the four regions" do
        rounds.each do |round|
          expect(round.regions).to eq(Team::REGIONS)
        end
      end
    end

    context "last two rounds" do
      let(:rounds) do
        [tournament.num_rounds - 1, tournament.num_rounds].map do |i|
          build(:round, tournament: tournament, number: i)
        end
      end

      it "is nil" do
        rounds.each do |round|
          expect(round.regions).to be_nil
        end
      end
    end
  end

  describe "name" do
    subject { build(:round, tournament: tournament, number: 1) }

    context "full tournament" do
      let(:tournament) { create(:tournament) }

      it "has the earlier round names" do
        expect(subject.name).to eq(Round::NAMES.first)
      end
    end

    context "sweet 16 tournament" do
      let(:tournament) { create(:tournament, :sweet_16) }

      it "has the later round names" do
        expect(subject.name).to eq(Round::NAMES.third)
      end
    end
  end

  describe "start_date" do
    subject { build(:round, tournament: tournament) }

    context "full tournament" do
      let(:tournament) { create(:tournament) }
      let(:expected_days) { [0, 2, 7, 9, 16, 18] }

      it "is the correct dates for all six rounds" do
        expected_days.each_with_index do |extra_days, i|
          round_number = i + 1
          subject.number = round_number
          expect(subject.start_date).to eq(tournament.tip_off.to_date + extra_days.days)
        end
      end
    end

    context "sweet 16" do
      let(:tournament) { create(:tournament, :sweet_16) }
      let(:expected_days) { [0, 2, 9, 11] }

      it "is the correct dates for all four rounds" do
        expected_days.each_with_index do |extra_days, i|
          round_number = i + 1
          subject.number = round_number
          expect(subject.start_date).to eq(tournament.tip_off.to_date + extra_days.days)
        end
      end
    end
  end

  describe "end_date" do
    subject { build(:round, tournament: tournament) }

    context "full tournament" do
      let(:tournament) { create(:tournament) }

      context "first rounds" do
        let(:round_numbers) { (1..4).to_a }

        it "is a day after the start_date" do
          round_numbers.each do |number|
            subject.number = number
            expect(subject.end_date).to eq(subject.start_date + 1.day)
          end
        end
      end

      context "last two rounds" do
        let(:round_numbers) { [5, 6] }

        it "is the start_date" do
          round_numbers.each do |number|
            subject.number = number
            expect(subject.end_date).to eq(subject.start_date)
          end
        end
      end
    end

    context "sweet 16 tournament" do
      let(:tournament) { create(:tournament, :sweet_16) }

      context "first rounds" do
        let(:round_numbers) { [1, 2] }

        it "is a day after the start_date" do
          round_numbers.each do |number|
            subject.number = number
            expect(subject.end_date).to eq(subject.start_date + 1.day)
          end
        end
      end

      context "last two rounds" do
        let(:round_numbers) { [3, 4] }

        it "is the start_date" do
          round_numbers.each do |number|
            subject.number = number
            expect(subject.end_date).to eq(subject.start_date)
          end
        end
      end
    end
  end
end
