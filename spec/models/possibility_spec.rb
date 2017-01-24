require "rails_helper"

RSpec.describe Possibility do
  let(:tournament) { create(:tournament, :completed) }
  let(:pool) { create(:pool, tournament: tournament) }
  let(:bracket) { create(:bracket, :completed, pool: pool) }

  subject { Possibility.new championships: [tournament.championship], best_brackets: [[bracket]] }

  it "has championships and best brackets" do
    expect(subject.championships.first).to be_a(Game)
    expect(subject.best_brackets.first.first).to be_a(Bracket)
  end
end
