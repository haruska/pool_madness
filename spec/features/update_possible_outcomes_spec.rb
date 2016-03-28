require "rails_helper"

RSpec.describe "Update Possible Outcomes" do
  context "all first places not showing up" do
    let(:tournament) { create(:tournament, num_rounds: 6, game_decisions: 15_429_987_744_522_996_224, game_mask: 18_446_744_073_709_551_360) }
    let(:pool) { create(:pool, tournament: tournament) }

    let!(:brackets_in_position) do
      [
        [1_603_932_492_831_430_890, 1_319_084_231_022_668_474, 5_359_864_143_956_976_160, 5_908_724_955_950_657_190, 437_487_269_544_110_214], # 1st
        [6_485_838_853_124_688_042, 3_611_959_514_300_468_940, 1_306_695_115_893_164_718, 5_765_258_437_858_994_722], # 2nd
        [1_315_702_115_941_141_674, 1_594_364_500_771_646_464, 655_389_644_070_962], # 3rd
        [6_508_354_685_356_248_746, 5_913_883_933_831_396_270] # eliminated
      ].map do |tree_decisions_arr|
        tree_decisions_arr.map do |tree_decisions|
          create(:bracket, pool: pool, tree_decisions: tree_decisions, tree_mask: 18_446_744_073_709_551_614)
        end
      end
    end

    before do
      ActiveJob::Base.queue_adapter = :inline
      UpdatePossibleOutcomesJob.perform_now(tournament.id)
    end

    after do
      ActiveJob::Base.queue_adapter = :test
    end

    it "has the correct best possibles" do
      brackets_in_position[0..2].each_with_index do |brackets, position|
        brackets.each do |bracket|
          expect(bracket.reload.best_possible).to eq(position)
        end
      end

      brackets_in_position.last.each do |bracket|
        expect(bracket.reload.best_possible).to be > 2
      end
    end
  end
end
