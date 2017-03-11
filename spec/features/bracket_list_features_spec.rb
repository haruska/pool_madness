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

    context "and the current user has not filled out a bracket" do
      it "has a New Bracket Entry action" do
        expect(page).to have_button("New Bracket Entry")
      end
    end

    context "and the current user has filled out brackets" do
      let!(:other_brackets) { create_list(:bracket, 3, :completed, pool: pool) }
      let!(:brackets) { create_list(:bracket, 3, :completed, user: user, pool: pool) }

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
    end

    context "with an unpaid bracket" do
      let!(:bracket) { create(:bracket, :completed, user: user, pool: pool) }

      it "indicates the bracket is unpaid" do
        expect(page).to have_selector(".bracket-status span", text: "Unpaid")
      end

      it "has an action to pay for brackets" do
        expect(page).to have_button("Pay Now")
      end
    end

    context "with a paid bracket" do
      let!(:bracket) { create(:bracket, :completed, :paid, user: user, pool: pool) }

      it "indicates the bracket is paid" do
        expect(page).to have_selector(".bracket-status span", text: "OK")
      end

      it "does not have a payment action" do
        expect(page).to have_button("Another Bracket")
        expect(page).to_not have_button("Pay Now")
      end
    end
  end

  context "when a pool has started" do
    let(:tournament) { create(:tournament, :started) }
    let!(:brackets) { create_list(:bracket, 3, :completed, pool: pool) }
    let(:bracket) { brackets.sample }
    let(:user) { bracket.user }

    before { visit "/pools/#{pool.id}/brackets" }

    it "shows a count of all brackets in the title" do
      expect(page).to have_selector(".title", text: /Brackets.*#{brackets.size} total/i)
    end

    it "shows details of all brackets" do
      within(".bracket-list") do
        brackets.each do |bracket|
          within(".bracket-#{bracket.id}") do
            expect(page).to have_selector(".name", text: bracket.name)
            bracket.sorted_four.each do |team|
              expect(page).to have_selector(".final-four-team", text: team.name)
            end
          end
        end
      end
    end

    it "shows the current place, total points, and points possible" do
      within(".bracket-list") do
        brackets.each do |bracket|
          within(".bracket-#{bracket.id}") do
            expect(page).to have_selector(".position", text: /\d+\./)
            expect(page).to have_selector(".points", text: bracket.points)
            expect(page).to have_selector(".possible", text: bracket.possible_points)
          end
        end
      end
    end

    it "highlights the current user's brackets" do
      expect(page).to have_selector(".bracket-#{bracket.id}.current-user-bracket")
    end

    context "and eliminations are not calculated" do
      it "does not show best possible finish" do
        expect(page).to have_selector("th", text: "Possible")
        expect(page).to_not have_selector("th", text: "Best")
        expect(page).to_not have_selector(".best-possible")
      end
    end

    context "and there are eliminations" do
      let(:tournament) { create(:tournament, :with_first_two_rounds_completed) }

      before do
        brackets.each_with_index do |bracket, i|
          bracket.bracket_point.update(best_possible: i)
        end

        visit "/pools/#{pool.id}/brackets"
      end

      it "shows best possible finish" do
        expect(page).to have_selector("th", text: "Best")
        brackets.each do |bracket|
          within(".bracket-#{bracket.id}") do
            expect(page).to have_selector(".best-possible", text: (bracket.best_possible + 1).ordinalize)
          end
        end
      end
    end
  end
end
