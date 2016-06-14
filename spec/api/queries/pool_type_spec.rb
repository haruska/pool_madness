require "rails_helper"

RSpec.describe Queries::PoolType do
  subject { Queries::PoolType }

  context "fields" do
    let(:fields) { %w(id model_id tournament name invite_code brackets display_best started) }

    it "has the proper fields" do
      expect(subject.fields.keys).to match_array(fields)
    end

    describe "model_id" do
      subject { Queries::PoolType.fields["model_id"] }

      let!(:pool) { create(:pool) }

      it "is the DB id of the object" do
        expect(subject.resolve(pool, nil, nil)).to eq(pool.id)
      end
    end

    describe "brackets" do
      subject { Queries::PoolType.fields["brackets"] }

      context "pool has started" do
        let!(:pool) { create(:pool) }
        let!(:brackets) { create_list(:bracket, 3, pool: pool) }
        let(:resolved_obj) { subject.resolve(pool, nil, current_user: create(:user)).object }

        it "is a list of brackets for the pool" do
          expect(resolved_obj).to match_array(brackets)
        end

        describe "sorting" do
          context "with best_possible" do
            before do
              brackets.first.bracket_point.update(best_possible: 1)
              brackets.second.bracket_point.update(best_possible: 2)
              brackets.third.bracket_point.update(best_possible: 0)
            end

            it "is primarily sorted by best_possible" do
              expect(resolved_obj).to eq([brackets.third, brackets.first, brackets.second])
            end
          end

          context "with more than one best_possible" do
            before do
              brackets.first.bracket_point.update(best_possible: 0, points: 0)
              brackets.second.bracket_point.update(best_possible: 2, points: 2)
              brackets.third.bracket_point.update(best_possible: 0, points: 1)
            end

            it "is then sorted by actual points" do
              expect(resolved_obj).to eq([brackets.third, brackets.first, brackets.second])
            end
          end

          context "with more than one best_possible and equal points" do
            before do
              brackets.first.bracket_point.update(best_possible: 0, points: 1, possible_points: 3)
              brackets.second.bracket_point.update(best_possible: 2, points: 2, possible_points: 3)
              brackets.third.bracket_point.update(best_possible: 0, points: 1, possible_points: 4)
            end

            it "is finally sorted by possible_points" do
              expect(resolved_obj).to eq([brackets.third, brackets.first, brackets.second])
            end
          end
        end
      end

      context "pool has not started" do
        let!(:pool) { create(:pool, tournament: create(:tournament, :not_started)) }
        let!(:brackets) { create_list(:bracket, 3, pool: pool) }
        let(:bracket) { brackets.sample }
        let(:user) { bracket.user }

        it "is a list of the current user's brackets" do
          resolved_obj = subject.resolve(pool, nil, current_user: user).object

          expect(resolved_obj).to eq([bracket])
        end
      end
    end
  end
end
