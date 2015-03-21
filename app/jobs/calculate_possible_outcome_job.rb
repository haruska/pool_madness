class CalculatePossibleOutcomeJob < ActiveJob::Base
  REDIS_LIST_KEY_PREFIX = "possible_outcome_bits_list_"

  def self.redis_list_key(pool)
    REDIS_LIST_KEY_PREFIX + pool.id.to_s
  end

  def perform(tournament_id)
    ActiveRecord::Base.cache do
      Tournament.find(tournament_id).pools.each do |pool|
        outcome_set = PossibleOutcomeSet.new(pool: pool)
        bits = pop_bits(pool)

        until bits.nil?
          outcome = outcome_set.generate_outcome(bits)
          outcome.update_brackets_best_possible

          bits = pop_bits(pool)
        end
      end
    end
  end

  private

  def pop_bits(pool)
    bits = nil

    Sidekiq.redis do |redis|
      bits = redis.lpop(self.class.redis_list_key(pool))
    end

    bits.try(:to_i)
  end
end