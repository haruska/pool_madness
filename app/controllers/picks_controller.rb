class PicksController < ApplicationController
  load_and_authorize_resource

  def update
    @pick.update(pick_params)
    render nothing: true
  end

  private

  def pick_params
    params.require(:pick).permit(:game_id, :choice)
  end
end
