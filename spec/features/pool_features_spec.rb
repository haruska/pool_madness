require "rails_helper"

RSpec.describe "Pools", js: true do
  describe "Pool List" do
    let(:tournament) { create(:tournament, :completed) }
    let(:archived_tournament) { create(:tournament, :completed, tip_off: 1.year.ago) }
    let(:pool) { create(:pool, tournament: tournament) }
    let(:archived_pool) { create(:pool, tournament: archived_tournament) }
    let(:user) { create(:pool_user, pool: pool).user }
    let!(:archived_pool_user) { create(:pool_user, pool: archived_pool, user: user) }

    context "with no current pools" do
      context "and no previous year pools" do
        before do
          sign_in create(:user)
          visit "/"
        end

        it "informs that you are not a member of any pools" do
          expect(page).to have_text("You are not a member of any tournament pools.")
        end

        it "does not have a link to previous years" do
          expect(page).to_not have_selector(".button", text: "Previous Years")
        end
      end

      context "with previous year pools" do
        let(:old_user) { create(:user) }
        let!(:pool_user) { create(:pool_user, pool: archived_pool, user: old_user) }

        before do
          sign_in old_user
          visit "/pools"
        end

        it "informs that you are not a member of any pools" do
          expect(page).to have_text("You are not a member of any tournament pools.")
        end

        it "has a link to previous years pools" do
          expect(page).to have_selector(".button", text: "Previous Years")
        end
      end
    end

    context "current pools" do
      before do
        sign_in user
        visit "/"
      end

      it "shows current pools only" do
        expect(page).to have_text(pool.name)
        expect(page).to_not have_text(archived_pool.name)
      end

      it "shows the tournament name" do
        expect(page).to have_text(pool.tournament.name)
      end

      context "before tip off" do
        let(:tournament) { create(:tournament, :not_started) }

        it "shows the invite code" do
          expect(page).to have_text(pool.invite_code)
        end
      end

      context "after tip off" do
        let(:tournament) { create(:tournament, :started) }

        before do
          expect(page).to have_text(pool.name)
        end

        it "does not show the invite code" do
          expect(page).to_not have_text(pool.invite_code)
        end
      end
    end

    context "archived pools" do
      before do
        sign_in user
        visit "/"
        find(".button", text: "Previous Years").click
      end

      it "shows archived pools only" do
        expect(page).to have_text(archived_pool.name)
        expect(page).to_not have_text(pool.name)
      end

      it "has a archived title and a link back to current pools" do
        expect(page).to have_text("Archived Pools")
        expect(page).to have_css(".button", text: /current pools/i)
      end
    end
  end

  describe "Pool details" do
    let(:pool) { create(:pool, tournament: tournament) }
    let(:user) { create(:pool_user, pool: pool).user }

    before do
      sign_in user
      visit "/pools/#{pool.id}"
    end

    context "when the pool has started" do
      let(:tournament) { create(:tournament, :started) }

      it "directs the user to the full bracket list" do
        within("header") do
          expect(page).to have_text(/Brackets.*total/)
        end
      end
    end

    context "when the pool has not started" do
      let(:tournament) { create(:tournament, :not_started) }

      it "directs the user to My Brackets" do
        within("header") do
          expect(page).to have_text("My Brackets")
        end
      end
    end
  end
end
