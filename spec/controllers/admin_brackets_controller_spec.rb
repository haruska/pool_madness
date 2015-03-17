require 'spec_helper'

describe AdminBracketsController, type: :controller do
  before(:all) do
    @tournament = create(:tournament)
  end

  let(:tournament) { @tournament }

  describe "#index" do
    render_views

    let(:pool) { create(:pool, tournament: tournament) }
    let(:user) { create(:user) }

    before do
      pool.users << user
      sign_in(user)
    end

    context "a regular user" do

      it "redirects home with an authorization message" do
        get :index, pool_id: pool.id
        expect(response).to redirect_to(root_path)
        expect(subject).to set_flash
      end
    end

    context "a pool admin user" do
      before { user.pool_users.first.admin! }

      it "is successful" do
        get :index, pool_id: pool.id

        expect(response).to be_success
      end

      context "with a set of brackets in the pool" do
        let!(:brackets) { create_list(:bracket, 3, :completed, pool: pool) }
        let!(:incomplete_bracket) { create(:bracket, pool: pool) }

        before {
          brackets.first.paid!
        }

        it "renders a list of brackets" do
          get :index, pool_id: pool.id

          brackets.each do |bracket|
            expect(response.body).to have_content(bracket.name)
            expect(response.body).to have_content(bracket.user.name)
            expect(response.body).to have_css("tr#bracket-#{bracket.id}")
            expect(response.body).to have_css("tr#bracket-#{bracket.id} .status-cell", text: /#{bracket.status}/i)
          end
        end
      end
    end
  end
end
