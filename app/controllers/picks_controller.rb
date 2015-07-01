class PicksController < ApplicationController
  load_and_authorize_resource :bracket

  def update
    @bracket.update_choice(pick_params[:id].to_i, pick_params[:choice].to_i)
    @bracket.save
    render nothing: true
  end

  private

  def pick_params
    params.permit(:id, :choice)
  end
end
