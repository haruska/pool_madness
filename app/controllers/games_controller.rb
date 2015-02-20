class GamesController < ApplicationController
  load_and_authorize_resource

  layout "bracket", only: "index"

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @game.update_attributes(game_params)
      redirect_to games_path, notice: "Updated score."
    else
      render "edit", alert: "Problem updating game."
    end
  end

  private

  def game_params
    params.require(:game).permit(:team_one, :team_two, :game_one, :game_two, :score_one, :score_two)
  end
end
