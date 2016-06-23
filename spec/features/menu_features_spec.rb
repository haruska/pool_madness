require "rails_helper"

RSpec.describe "Menu", js: true do
  context "Logged in" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit("/")
    end

    it "has standard signed in links" do
      find(".fa-bars").click
      expect(page).to have_link("Enter Invite Code", href: "/pools/invite_code")
      expect(page).to have_link("Profile", href: "/user")
      expect(page).to have_link("Logout", href: "/auth/sign_out")
    end

    describe "Logout link" do
      it "logs the user out of the system" do
        find(".fa-bars").click
        click_link "Logout"

        expect(page).to have_text(/private pool/i)
        find(".fa-bars").click
        expect(page).to have_link("Login")
      end
    end

    context "Outside of a Pool" do
      it "has a link to All Pools" do
        find(".fa-bars").click
        expect(page).to have_link("All Pools", href: "/pools")
      end
    end

    context "Within a Pool" do
      let(:pool) { create(:pool, tournament: tournament) }
      let!(:pool_user) { create(:pool_user, pool: pool, user: user) }

      before do
        visit "/pools/#{pool.id}"
        find(".fa-bars").click
      end

      context "when a pool has not started" do
        let(:tournament) { create(:tournament, :not_started) }

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

      context "when a pool has started" do
        let(:tournament) { create(:tournament, :started) }

        it "has a link to game results" do
          expect(page).to have_link("Game Results", href: pool_games_path(pool))
        end

        it "does not have a link to types of payment" do
          expect(page).to have_link("Brackets")
          expect(page).to_not have_link("Types of Payment")
        end

        context "and the tournament is in the final four" do
          let(:tournament) { create(:tournament, :in_final_four) }

          it "has a link to possible outcomes" do
            expect(page).to have_link("Possible Outcomes", href: pool_possibilities_path(pool))
          end
        end

        context "and the tournament is in an earlier round" do
          it "does not have a link to possible outcomes" do
            expect(page).to have_link("Brackets")
            expect(page).to_not have_link("Possible Outcomes")
          end
        end
      end

      context "when a pool has finished" do
        let(:tournament) { create(:tournament, :completed) }

        it "does not have a link to possible outcomes" do
          expect(page).to have_link("Brackets")
          expect(page).to_not have_link("Possible Outcomes")
        end
      end

      describe "pool administrator links" do
        let(:tournament) { create(:tournament) }

        before do
          sign_in user
          visit "/pools/#{pool.id}"
          find(".fa-bars").click
        end

        context "as a regular user" do
          it "does not have a link to the pool admin page" do
            expect(page).to have_link("Brackets")
            expect(page).to_not have_link("Pool Admin", href: admin_pool_brackets_path(pool))
          end
        end

        context "as a pool admin" do
          let!(:pool_admin) { create(:pool_user, pool: pool, role: :admin).user }

          before do
            sign_in pool_admin
            visit "/pools/#{pool.id}"
            find(".fa-bars").click
          end

          it "has a link to the pool admin page" do
            expect(page).to have_link("Pool Admin", href: admin_pool_brackets_path(pool))
          end
        end

        context "as a site admin" do
          let(:user) { create(:admin_user) }

          it "has a link to the pool admin page" do
            expect(page).to have_link("Pool Admin", href: admin_pool_brackets_path(pool))
          end
        end
      end
    end
  end
end
