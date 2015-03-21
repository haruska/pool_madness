class UpdatePossibleOutcomesJob < ActiveJob::Base
  def perform(tournament_id)
    timestamp = Time.now.to_i

    Tournament.find(tournament_id).pools.each do |pool|
      outcome_set_key = self.class.outcome_set_key(tournament_id, timestamp, pool.id)

      Sidekiq.redis do |redis|
        PossibleOutcomeSet.new(pool: pool).all_slot_bits do |sb|
          redis.lpush(outcome_set_key, sb)
        end
      end

      4.times { CalculatePossibleOutcomeJob.perform_later(tournament_id, timestamp) }
    end
  end

  def self.outcome_set_key(tournament_id, timestamp, pool_id)
    "outcomeset_#{tournament_id}_#{timestamp}_#{pool_id}"
  end
end
