require "spec_helper"

describe Pool, type: :model do
  before(:all) { @tournament = create(:tournament) }
  let(:tournament) { @tournament }
  subject { create(:pool, tournament: tournament) }

  context "tournament hasn't started" do
    before { tournament.update(tip_off: 4.days.from_now) }

    it "has not started" do
      expect(subject).to_not be_started
    end

    it "has not started eliminating" do
      expect(subject).to_not be_start_eliminating
    end
  end

  context "tournament has already started" do
    context "first weekend" do
      before { tournament.update(tip_off: 1.day.ago) }

      it "has not started eliminating" do
        expect(subject).to_not be_start_eliminating
      end

      it "has already started" do
        expect(subject).to be_started
      end
    end

    context "second weekend" do
      before { tournament.update(tip_off: 1.week.ago) }

      it "has started eliminating" do
        expect(subject).to be_start_eliminating
      end

      it "has already started" do
        expect(subject).to be_started
      end
    end
  end
end
