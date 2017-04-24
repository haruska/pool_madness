class UpdateAllBracketScoresJob < ApplicationJob
  queue_as :scores

  def perform(tournament_id)
    Tournament.find(tournament_id).pools.each do |pool|
      pool.brackets.select(:id).all.each do |b|
        BracketScoreJob.perform_later(b.id)
      end
    end
  end
end
