class BracketsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :pool, only: [:index, :create]
  load_and_authorize_resource :bracket, through: :pool, only: [:create]
  load_and_authorize_resource :bracket, except: [:index, :create]

  before_action :load_pool, except: [:index, :create]

  def index
    if @pool.started?
      @brackets = @pool.brackets.includes(:bracket_point).joins(:bracket_point).order("best_possible asc", "points desc", "possible_points desc")
      set_jskit_index_payload
    else
      @brackets = @pool.brackets.where(user_id: current_user).to_a
      @brackets.sort_by! { |x| [[:ok, :unpaid, :incomplete].index(x.status), x.name] }
      @unpaid_brackets = @brackets.select {|b| b.unpaid? }
    end
  end

  def show
    set_jskit_show_payload
  end

  def edit
    set_jskit_edit_payload
  end

  def create
    @bracket.pool = @pool

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

  def load_pool
    @pool = @bracket.pool
  end

  def update_params
    params.require(:bracket).permit(:tie_breaker, :name, :points, :possible_points)
  end

  def set_jskit_index_payload
    set_action_payload(current_user.brackets.where(pool_id: @pool.id).pluck(:id))
  end

  def set_jskit_show_payload
    max_updated_at = @bracket.tournament.games.maximum(:updated_at).to_i
    cache_key = "tournament-#{@bracket.tournament.id}/eliminated/all-#{max_updated_at}"

    eliminated_team_ids = Rails.cache.fetch(cache_key) do
      @bracket.tournament.teams.to_a.select { |team| team.eliminated? }.map(&:id)
    end

    set_action_payload(eliminated_team_ids)
  end

  def set_jskit_edit_payload
    game_transitions = {}
    game_to_pick = {}
    champ_game_id = @bracket.tournament.championship.id

    @bracket.tournament.games.all.each do |g|
      game_to_pick[g.id] = @bracket.picks.find_by(game_id: g.id).id
      game_transitions[g.id] = [g.next_game.id, g.next_slot] unless g.next_game.blank?
    end

    set_action_payload(game_transitions, game_to_pick, champ_game_id)
  end
end
