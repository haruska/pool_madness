class GamesController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource only: [:edit, :update]

  before_action :load_tournament, only: [:edit, :update]
  before_action :load_pool_tournament, :set_jskit_payload, only: [:index]

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

  def load_pool_tournament
    if params[:pool_id]
      @pool = Pool.find(params[:pool_id])
      authorize! :read, @pool
      @tournament = @pool.tournament
    else
      @tournament = Tournament.find(params[:tournament_id])
      authorize! :read, @tournament
    end
  end

  def game_params
    params.require(:game).permit(:score_one, :score_two)
  end

  def set_jskit_payload
    set_action_payload(can?(:edit, @tournament), games_url)
  end
end
