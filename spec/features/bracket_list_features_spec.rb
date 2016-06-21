require "rails_helper"

RSpec.describe "Bracket Lists", js: true do
  let(:pool) { create(:pool, tournament: tournament) }
  let(:user) { create(:pool_user, pool: pool).user }

  before do
    sign_in user
  end

  context "when a pool has not started" do
    let(:tournament) { create(:tournament, :not_started) }

    before do
      visit "/pools/#{pool.id}"
    end

    it "has the title 'My Brackets'" do
      expect(page).to have_selector(".title", text: "My Brackets")
    end

    describe "nav menu" do
      before do
        find(".fa-bars").click
      end

      it "has links pertaining to the current pool" do
        expect(page).to have_link("Brackets", href: pool_path(pool))
        expect(page).to have_link("Rules and Scoring", href: rules_pool_path(pool))
        expect(page).to have_link("Other Pools", href: pools_path)
        expect(page).to_not have_link("All Pools")
      end

      it "has a link to types of payment" do
        expect(page).to have_link("Types of Payment", href: payments_pool_path(pool))
      end

      it "does not have links to possible outcomes or game results" do
        expect(page).to_not have_link("Possible Outcomes")
        expect(page).to_not have_link("Game Results")
      end
    end

    context "and the current user has not filled out a bracket" do
      it "has a New Bracket Entry action" do
        expect(page).to have_button("New Bracket Entry")
      end
    end

    context "and the current user has filled out brackets" do
      let!(:other_brackets) { create_list(:bracket, 3, :completed, pool: pool) }
      let!(:brackets) { create_list(:bracket, 3, :completed, user: user, pool: pool)}

      before do
        visit "/pools/#{pool.id}"
      end

      it "shows details of the user's brackets" do
        within(".user-bracket-list") do
          brackets.each do |bracket|
            within(".bracket-#{bracket.id}") do
              expect(page).to have_selector(".bracket-name", text: bracket.name)
              expect(page).to have_selector(".bracket-tie-breaker", text: bracket.tie_breaker)
              expect(page).to have_selector(".bracket-status span")
              bracket.sorted_four.each do |team|
                expect(page).to have_selector(".bracket-final-four", text: team.name)
              end
            end
          end
        end
      end

      it "does not show other users brackets" do
        other_brackets.each do |bracket|
          expect(page).to_not have_selector(".bracket-#{bracket.id}")
          expect(page).to_not have_text(bracket.name)
        end
      end

      it "has a Another Bracket Entry action" do
        expect(page).to have_selector("button.minor", text: "Another Bracket Entry")
      end

      context "with an incomplete bracket" do
        it "indicates the bracket is incomplete"
      end

      context "with an unpaid bracket" do
        it "indicates the bracket is unpaid"
        it "has an action to pay for brackets"
      end

      context "with a paid bracket" do
        it "indicates the bracket is paid"
      end
    end
  end
end
