class Scheduler
  include Sidekiq::Worker

  def perform
    FetchGameScores.perform_async
    Scheduler.perform_in(1.minute)
  end
end