class UpdateGameScoresJob < ActiveJob::Base

  def perform
    yesterday = SportsScores.generate_for(Date.yesterday)
    today = SportsScores.generate_for(Date.today)

    yesterday.update_scores
    today.update_scores
    next_time = [today.next_poll_time, yesterday.next_poll_time].min

    if yesterday.changed_games || today.changed_games
      Tournament.all.each do |tournament|
        UpdateAllBracketScoresJob.perform_later(tournament.id)

        if tournament.start_eliminating?
          UpdatePossibleOutcomesJob.perform_later(tournament.id)
        end
      end
    end

    UpdateGameScoresJob.set(wait_until: next_time).perform_later
  end
end
