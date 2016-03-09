require "rails_helper"

RSpec.describe "Pools", js: true do
  describe "Pool List" do
    let(:tournament) { create(:tournament, :completed) }
    let(:archived_tournament) { create(:tournament, :completed, tip_off: 1.year.ago) }
    let(:pool) { create(:pool, tournament: tournament) }
    let(:archived_pool) { create(:pool, tournament: archived_tournament) }
    let(:user) { create(:pool_user, pool: pool).user }
    let!(:archived_pool_user) { create(:pool_user, pool: archived_pool, user: user)}

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
        find(".fa-bars").click
        click_link "Archived Pools"
      end

      it "shows archived pools only" do
        expect(page).to have_text(archived_pool.name)
        expect(page).to_not have_text(pool.name)
      end

      it "has a archived title and a link back to current pools" do
        expect(page).to have_text("Archived Pools")
        expect(page).to have_css("a", text: /current pools/i)
      end
    end
  end
end
