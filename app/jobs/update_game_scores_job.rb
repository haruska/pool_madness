class UpdateGameScoresJob < ActiveJob::Base

  def perform
    yesterday = SportsScores.generate_for(Date.yesterday)
    today = SportsScores.generate_for(Date.today)

    yesterday.update_scores
    today.update_scores

    if yesterday.changed_games || today.changed_games
      Tournament.all.each do |tournament|
        UpdateAllBracketScoresJob.perform_later(tournament.id)
      end
    end

    UpdateGameScoresJob.set(wait_until: today.next_poll_time).perform_later
  end
end
