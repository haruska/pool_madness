class BracketsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :pool, only: [:create]
  load_and_authorize_resource :bracket, through: :pool, only: [:create]
  load_and_authorize_resource :bracket, except: [:create]

  before_action :load_pool_and_tournament, except: [:create]

  def show
    if !@pool.started? && current_user == @bracket.user
      redirect_to edit_bracket_path(@bracket)
    end

    set_jskit_show_payload
  end

  def edit
    set_jskit_edit_payload
  end

  def create
    @bracket.pool = @pool
    @bracket.user = current_user

    if @bracket.save
      redirect_to edit_bracket_path(@bracket)
    else
      redirect_to pool_path(@pool), alert: "Problem creating a new bracket. Please try again."
    end
  end

  def update
    if @bracket.update(update_params)
      redirect_to pool_path(@pool), notice: "Bracket Saved"
    else
      flash.now[:error] = "Problem saving bracket. Please try again"
      render :edit
    end
  end

  def destroy
    @bracket.destroy
    redirect_to pool_path(@pool), notice: "Bracket Destroyed"
  end

  private

  def load_pool_and_tournament
    @pool = @bracket.pool
    @tournament = @bracket.tournament
  end

  def update_params
    params.require(:bracket).permit(:tie_breaker, :name, :points, :possible_points)
  end

  def set_jskit_show_payload
    set_action_payload(@bracket.id, @bracket.games_hash, @bracket.tie_breaker)
  end

  def set_jskit_edit_payload
    set_action_payload(@bracket.id, @bracket.games_hash)
  end
end
