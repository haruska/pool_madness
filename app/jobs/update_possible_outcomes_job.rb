class UpdatePossibleOutcomesJob < ActiveJob::Base
  def perform(tournament_id)
    Tournament.find(tournament_id).pools.each do |pool|
      pool.bracket_points.update_all(best_possible: 60000)

      Sidekiq.redis do |redis|
        PossibleOutcomeSet.new(pool: pool).all_slot_bits do |sb|
          redis.lpush(CalculatePossibleOutcomeJob.redis_list_key(pool), sb)
        end
      end

      4.times { CalculatePossibleOutcomeJob.perform_later(tournament_id) }
    end
  end
end
