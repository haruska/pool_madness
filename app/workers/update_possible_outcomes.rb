class UpdatePossibleOutcomes
  include Sidekiq::Worker

  def perform
    PossibleOutcome.destroy_all
    PossibleGame.destroy_all

    Bracket.all.each do |bracket|
      bracket.best_possible = 10000
      bracket.save!
    end

    PossibleOutcome.generate_all_slot_bits do |slot_bits|
      CalculatePossibleOutcome.perform_async(slot_bits)
    end
  end

end

