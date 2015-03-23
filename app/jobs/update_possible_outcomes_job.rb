class UpdatePossibleOutcomesJob < ActiveJob::Base
  def perform(tournament_id)
    timestamp = Time.now.to_i
    pool = Tournament.find(tournament_id).pools.first
    outcome_set_key = self.class.outcome_set_key(tournament_id, timestamp)

    Sidekiq.redis do |redis|
      PossibleOutcomeSet.new(pool: pool).all_slot_bits do |sb|
        redis.lpush(outcome_set_key, sb)
      end
    end

    4.times { CalculatePossibleOutcomeJob.perform_later(tournament_id, timestamp) }
  end

  def self.outcome_set_key(tournament_id, timestamp)
    "outcomeset_#{tournament_id}_#{timestamp}"
  end
end
