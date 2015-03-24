class UpdatePossibleOutcomesJob < ActiveJob::Base
  def perform(tournament_id, opts = {})
    opts = HashWithIndifferentAccess.new(update_db: true).merge(opts)

    timestamp = Time.now.to_i
    tournament = Tournament.find(tournament_id)
    outcome_set_key = self.class.outcome_set_key(tournament_id, timestamp)
    outcome_set = PossibleOutcomeSet.new(tournament: tournament)

    Sidekiq.redis { |redis| redis.set outcome_set_key, outcome_set.min_slot_bits }

    4.times { CalculatePossibleOutcomeJob.perform_later(tournament_id, timestamp, opts) }
  end

  def self.outcome_set_key(tournament_id, timestamp)
    "outcomeset_#{tournament_id}_#{timestamp}"
  end
end
