require "rails_helper"

RSpec.describe "Pool Rules", js: true do
  let(:tournament) { create(:tournament, :not_started) }
  let(:pool) { create(:pool, tournament: tournament) }
  let(:user) { create(:pool_user, pool: pool).user }
  let!(:pool_admins) { create_list(:pool_user, 2, pool: pool, role: :admin).map(&:user) }

  let(:deadline) { tournament.tip_off.in_time_zone("America/New_York").strftime("%A %B %e, %Y at %l:%M%P %Z") }

  before do
    sign_in user
    visit "/pools/#{pool.id}/rules"
  end

  it "shows the entry amount" do
    expect(page).to have_text("$#{pool.entry_fee / 100}")
  end

  it "shows the entry deadline" do
    expect(page).to have_text(deadline)
  end

  it "has a list of pool admins" do
    pool_admins.each do |admin|
      expect(page).to have_selector("li", text: admin.name)
    end
  end

  context "tournament has more than four rounds" do
    it "shows scoring for the fifth and sixth rounds" do
      expect(page).to have_text("Fifth")
      expect(page).to have_text("8 + Seed Number")
      expect(page).to have_text("Sixth")
      expect(page).to have_text("13 + Seed Number")
    end
  end

  context "tournament has under five rounds" do
    let(:tournament) { create(:tournament, num_rounds: 4) }

    it "does not show scoring for the fifth and sixth rounds" do
      expect(page).to_not have_text("Fifth")
      expect(page).to_not have_text("8 + Seed Number")
      expect(page).to_not have_text("Sixth")
      expect(page).to_not have_text("13 + Seed Number")
    end
  end

  context "Tournament has started" do
    let(:tournament) { create(:tournament, :started) }
    let!(:brackets) { create_list(:bracket, 5, :completed, pool: pool, payment_state: :paid) }

    before do
      visit "/pools/#{pool.id}/rules"
    end

    it "shows amounts for first, second and third place" do
      [0.7, 0.2, 0.1].each do |percent|
        amount = (pool.total_collected * percent).to_i
        expect(amount).to_not be_zero
        expect(page).to have_text("$#{amount}")
      end
    end
  end
end
