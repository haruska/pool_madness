require "spec_helper"

describe Pool, type: :model do
  subject { Pool.new }

  it "has a tip_off that defaults to TIP_OFF" do
    expect(subject.tip_off).to eq(Pool::TIP_OFF)
    expect(Pool.tip_off).to eq(Pool::TIP_OFF)
  end

  it "has already started" do
    expect(subject).to be_started
    expect(Pool).to be_started
  end

  it "has started eliminating" do
    expect(subject).to be_start_eliminating
    expect(Pool).to be_start_eliminating
  end

  context "before tip off" do
    subject { Pool.new(tip_off_attr: DateTime.tomorrow) }

    it "has not started" do
      expect(subject).to_not be_started
    end

    it "has not started eliminating" do
      expect(subject).to_not be_start_eliminating
    end
  end

  context "first day" do
    subject { Pool.new(tip_off_attr: DateTime.yesterday) }

    it "has started" do
      expect(subject).to be_started
    end

    it "has not started eliminating" do
      expect(subject).to_not be_start_eliminating
    end
  end

  context "after the first weekend" do
    subject { Pool.new(tip_off_attr: 4.days.ago) }

    it "has started" do
      expect(subject).to be_started
    end

    it "has started eliminating" do
      expect(subject).to be_start_eliminating
    end
  end
end
