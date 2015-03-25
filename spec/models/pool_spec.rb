require "spec_helper"

describe Pool, type: :model do
  before(:all) { @tournament = create(:tournament) }
  let(:tournament) { @tournament }
  subject { create(:pool, tournament: tournament) }

  it { should belong_to(:tournament) }
  it { should have_many(:brackets) }
  it { should have_many(:pool_users) }
  it { should have_many(:users).through(:pool_users) }

  it { should delegate_method(:tip_off).to(:tournament) }

  it { should validate_uniqueness_of :invite_code }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:tournament_id) }

  context "before validation" do
    subject { build(:pool, tournament: tournament) }

    it "generates a unique invite code" do
      expect(subject).to be_valid
      expect(subject.invite_code).to be_present
    end
  end

  context "tournament hasn't started" do
    before { tournament.update(tip_off: 4.days.from_now) }

    it "has not started" do
      expect(subject).to_not be_started
    end

    it "has not started eliminating" do
      expect(subject).to_not be_start_eliminating
    end

    it "has an entry_fee that defaults to 10 dollars" do
      expect(subject.entry_fee).to eq(1000)
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
      let(:tournament) { create(:tournament, :with_first_two_rounds_completed) }

      it "has started eliminating" do
        expect(subject).to be_start_eliminating
      end

      it "has already started" do
        expect(subject).to be_started
      end
    end
  end
end
