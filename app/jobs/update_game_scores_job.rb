class UpdateGameScoresJob < ActiveJob::Base
  queue_as :scores

  def perform
    yesterday = SportsScores.generate_for(Date.yesterday)
    today = SportsScores.generate_for(Date.today)

    yesterday.update_scores
    today.update_scores

    if yesterday.changed_games || today.changed_games
      Tournament.current.each do |tournament|
        UpdateAllBracketScoresJob.perform_later(tournament.id)

        if tournament.start_eliminating?
          UpdatePossibleOutcomesJob.perform_later(tournament.id)
        end
      end
    end

    next_poll_time = yesterday.started_games.present? || yesterday.not_started_games.present? ? 5.minutes.from_now : today.next_poll_time

    UpdateGameScoresJob.set(wait_until: next_poll_time).perform_later
  end
end
