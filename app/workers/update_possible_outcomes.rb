class UpdatePossibleOutcomes
  include Sidekiq::Worker

  def perform
  	PossibleOutcome.update_all
  	expire_action "/public/brackets"
  end

  private

  def controller
    @controller ||= ActionController::Base.new
  end

  def expire_action(action)
    controller.send(:expire_action, action)
  end
end

