class CalculatePossibleOutcome
  include Sidekiq::Worker

  def perform(slot_bits)
    po = PossibleOutcome.find_by_slot_bits(slot_bits) || PossibleOutcome.generate_outcome(slot_bits)
    po.update_brackets_best_possible
    po.destroy
  end
end
