class BracketsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :pool, only: [:index, :create]
  load_and_authorize_resource :bracket, through: :pool, only: [:index, :create]
  load_and_authorize_resource :bracket, except: [:index, :create]
  before_action :load_pool, except: [:index, :create]

  layout "bracket", except: [:index]

  def index
    @brackets = @brackets.to_a

    if @pool.started?
      @brackets.sort_by! { |x| [100_000 - [x.best_possible, 4].min, x.points, x.possible_points] }
      @brackets.reverse!
    else
      @brackets.sort_by! { |x| [[:ok, :unpaid, :incomplete].index(x.status), x.name] }
    end
  end

  def show
  end

  # def printable
  #   @bracket = Bracket.find(params[:id])
  #   authorize! :read, @bracket
  #
  #   render layout: false
  # end
  #
  # def create
  #   if @bracket.save
  #     redirect_to edit_bracket_path(@bracket)
  #   else
  #     redirect_to root_path, alert: "Problem creating a new bracket. Please try again."
  #   end
  # end
  #
  def update
    if @bracket.update(bracket_params)
      redirect_to @bracket, notice: "Bracket Saved"
    else
      flash.now[:alert] = "Problem saving bracket. Please try again"
      render :edit
    end
  end
  #
  # def destroy
  #   @bracket.destroy
  #   redirect_to root_path, notice: "Bracket Destroyed"
  # end
  #
  # def current_user_bracket_ids
  #   ids = current_user.brackets.pluck(:id)
  #   render json: ids.to_json
  # end

  private

  def load_pool
    @pool = @bracket.pool
  end

  def bracket_params
    params.require(:bracket).permit(:tie_breaker, :name, :points, :possible_points)
  end
end
