class UpdateAllBracketScoresJob < ActiveJob::Base
  queue_as :default

  def perform
    Bracket.select(:id).all.each do |b|
      BracketScoreJob.perform_later(b.id)
    end
  end
end
