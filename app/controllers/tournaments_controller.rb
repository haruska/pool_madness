class TournamentsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def edit; end

  def update
    if @tournament.update(tournament_params)
      flash[:success] = "Updated Tournament"
      redirect_to root_path
    else
      flash[:error] = "Problem updating Tournament"
      render :edit
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, teams_attributes: %i[id name score_team_id])
  end
end
