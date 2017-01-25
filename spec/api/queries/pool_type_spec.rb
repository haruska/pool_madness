require "rails_helper"

RSpec.describe Queries::PoolType do
  subject { Queries::PoolType }

  context "fields" do
    let(:fields) { %w(id model_id tournament name invite_code entry_fee total_collected brackets possibilities admins display_best started) }

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

    describe "admins" do
      subject { Queries::PoolType.fields["admins"] }

      let!(:pool) { create(:pool) }
      let!(:admins) { create_list(:pool_user, 2, pool: pool, role: :admin).map(&:user) }
      let(:resolved) { subject.resolve(pool, nil, current_user: create(:user)) }

      it "is a list of admin users for the pool" do
        expect(resolved).to match_array(admins)
      end
    end

    describe "brackets" do
      subject { Queries::PoolType.fields["brackets"] }

      context "pool has started" do
        let!(:pool) { create(:pool) }
        let!(:brackets) { create_list(:bracket, 3, pool: pool) }
        let(:resolved_obj) { subject.resolve(pool, nil, current_user: create(:user)).nodes }

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
          resolved_obj = subject.resolve(pool, nil, current_user: user).nodes

          expect(resolved_obj).to eq([bracket])
        end
      end
    end

    describe "#possibilities" do
      subject { Queries::PoolType.fields["possibilities"] }

      let(:pool) { create(:pool, tournament: tournament) }
      let!(:brackets) do
        Array.new(3) do
          bracket = create(:bracket, :completed, pool: pool)
          bracket.tree_decisions = tournament.game_decisions
          3.times { |i| bracket.update_choice(i + 1, [0, 1].sample) }
          bracket.save!
          bracket.paid!
          bracket.calculate_points
          bracket.calculate_possible_points
          bracket.bracket_point.update(best_possible: 0)
          bracket
        end
      end

      let(:resolved_field) { subject.resolve(pool, nil, nil) }

      context "with zero games remaining" do
        let(:tournament) { create(:tournament, :completed) }

        it "is nil" do
          expect(resolved_field).to be_nil
        end
      end

      context "before the final four" do
        let(:tournament) { create(:tournament) }

        before do
          (1..3).each do |round|
            tournament.round_for(round).each do |game|
              tournament.update_game(game.slot, [0, 1].sample)
            end
          end

          # fill out all round of eight except for one game
          tournament.round_for(4)[0...-1].each do |game|
            tournament.update_game(game.slot, [0, 1].sample)
          end

          tournament.save
        end

        it "is nil" do
          expect(resolved_field).to be_nil
        end
      end

      context "in the final four" do
        let(:tournament) { create(:tournament, :in_final_four) }
        let(:outcome_set) { PossibleOutcomeSet.new(tournament: pool.tournament) }

        it "is all outcomes by winners for the pool" do
          expect(resolved_field).to match_array(outcome_set.all_outcomes_by_winners(pool))
        end
      end
    end
  end
end
