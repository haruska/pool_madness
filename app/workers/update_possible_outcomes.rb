class UpdatePossibleOutcomes
  include Sidekiq::Worker

  def perform
    Bracket.update_all(:best_possible => 1000)

    Sidekiq.redis do |redis|
      PossibleOutcome.generate_all_slot_bits do |sb|
        redis.lpush(CalculatePossibleOutcome::LIST_KEY, sb)
      end
    end

    4.times { CalculatePossibleOutcome.perform_async }
  end
  
end

