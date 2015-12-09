class GamesController < ApplicationController
  before_action :authenticate_user!

  before_action :load_pool_tournament, :set_jskit_payload

  def index
  end

  private

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

  def set_jskit_payload
    set_action_payload(@tournament.games_hash)
  end
end
