class GamesController < ApplicationController
  load_and_authorize_resource :tournament, only: [:index]
  load_and_authorize_resource only: [:edit, :update]

  before_action :load_tournament, only: [:edit, :update]
  before_action :set_jskit_payload, only: [:index]

  def index
    @games = @tournament.games
  end

  def edit
  end

  def update
    if @game.update(game_params)
      @game.next_game.try(:touch)
      redirect_to tournament_games_path(@tournament), notice: "Updated score."
    else
      render "edit", alert: "Problem updating game."
    end
  end

  private

  def load_tournament
    @tournament = @game.tournament
  end

  def game_params
    params.require(:game).permit(:score_one, :score_two)
  end

  def set_jskit_payload
    set_action_payload(can?(:edit, @tournament), games_url)
  end
end
