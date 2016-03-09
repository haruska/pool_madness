class BracketsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :pool, only: [:index, :create]
  load_and_authorize_resource :bracket, through: :pool, only: [:create]
  load_and_authorize_resource :bracket, except: [:index, :create]

  before_action :load_pool_and_tournament, except: [:index, :create]

  def index
    if @pool.started?
      @brackets = @pool.brackets.includes(:bracket_point).joins(:bracket_point).order("best_possible asc", "points desc", "possible_points desc")
      set_jskit_index_payload
    else
      @brackets = @pool.brackets.where(user_id: current_user).to_a
      @brackets.sort_by! { |x| [[:ok, :unpaid, :incomplete].index(x.status), x.name] }
      @unpaid_brackets = @brackets.select(&:unpaid?)
    end
  end

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
      redirect_to pool_brackets_path(@pool), alert: "Problem creating a new bracket. Please try again."
    end
  end

  def update
    if @bracket.update(update_params)
      redirect_to pool_brackets_path(@pool), notice: "Bracket Saved"
    else
      flash.now[:error] = "Problem saving bracket. Please try again"
      render :edit
    end
  end

  def destroy
    @bracket.destroy
    redirect_to pool_brackets_path(@pool), notice: "Bracket Destroyed"
  end

  private

  def load_pool_and_tournament
    @pool = @bracket.pool
    @tournament = @bracket.tournament
  end

  def update_params
    params.require(:bracket).permit(:tie_breaker, :name, :points, :possible_points)
  end

  def set_jskit_index_payload
    set_action_payload(current_user.brackets.where(pool_id: @pool.id).pluck(:id))
  end

  def set_jskit_show_payload
    set_action_payload(@bracket.id, @bracket.games_hash)
  end

  def set_jskit_edit_payload
    set_action_payload(@bracket.id, @bracket.games_hash)
  end
end
