module Admin
  class TournamentsController < ApplicationController
    before_action :authenticate_user!

    load_and_authorize_resource

    def update_bracket_scores
      UpdateAllBracketScoresJob.perform_later(@tournament.id)
      flash[:success] = "UpdateAllBracketScores job enqueued."
      redirect_to tournament_games_path(@tournament)
    end
  end
end
