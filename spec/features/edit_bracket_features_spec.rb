require "rails_helper"

RSpec.describe "Editing a Bracket", js: true do
  let(:tournament) { create(:tournament, :not_started) }
  let(:pool) { create(:pool, tournament: tournament) }
  let(:user) { create(:pool_user, pool: pool).user }
  let(:bracket) { create(:bracket, pool: pool, user: user) }

  before do
    sign_in user
    visit "/brackets/#{bracket.id}"
    click_link "Edit Bracket"
  end

  it "allows you to select teams" do
    round_one = first(".round1 .match.m1 .slot1")
    round_one.click

    round_two = first(".round2 .match.m1 .slot1")

    expect(round_two.text).to eq(round_one.text)
    round_two.click

    round_three = first(".round3 .match.m1 .slot1")
    expect(round_three.text).to eq(round_two.text)
  end

  it "allows you to change your pick" do
    # select same team for round 1 and 2
    first(".round1 .match.m1 .slot1").click
    first(".round2 .match.m1 .slot1").click

    # select different team in first round
    first(".round1 .match.m1 .slot2").click

    # should update both picks to new team
    expect(first(".round2 .match.m1 .slot1").text).to eq(first(".round1 .match.m1 .slot2").text)
    expect(first(".round3 .match.m1 .slot1").text).to eq(first(".round1 .match.m1 .slot2").text)
  end

  it "saves the picks on 'done'" do
    first(".round1 .match.m1 .slot1").click
    first(".round2 .match.m1 .slot1").click
    fill_in("tie_breaker", with: "100")

    click_button "Done"
    expect(find(".bracket-show h2").text).to eq(bracket.name)

    expect(first(".round2 .match.m1 .slot1").text).to eq(first(".round1 .match.m1 .slot1").text)
    expect(first(".round3 .match.m1 .slot1").text).to eq(first(".round1 .match.m1 .slot1").text)
  end
end
