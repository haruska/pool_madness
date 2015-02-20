class PicksController < ApplicationController
  load_and_authorize_resource

  def update
    @pick.update_attributes(pick_params)
    render nothing: true
  end

  private

  def pick_params
    params.require(:pick).permit(:game_id, :team_id)
  end
end
