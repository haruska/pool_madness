class BracketsController < ApplicationController
  load_and_authorize_resource except: [:current_user_bracket_ids, :printable]

  layout "bracket", except: [:index]

  def index
    if Pool.started?
      @brackets.sort_by! { |x| [100_000 - [x.best_possible, 4].min, x.points, x.possible_points] }
      @brackets.reverse!
    else
      @brackets.sort_by! { |x| [[:ok, :unpaid, :incomplete].index(x.status), x.name] }
    end
  end

  def show
  end

  def printable
    @bracket = Bracket.find(params[:id])
    authorize! :read, @bracket

    render layout: false
  end

  def create
    if @bracket.save
      redirect_to edit_bracket_path(@bracket)
    else
      redirect_to root_path, alert: "Problem creating a new bracket. Please try again."
    end
  end

  def update
    if @bracket.update_attributes(bracket_params)
      redirect_to @bracket, notice: "Bracket Saved"
    else
      flash.now[:alert] = "Problem saving bracket. Please try again"
      render :edit
    end
  end

  def destroy
    @bracket.destroy
    redirect_to root_path, notice: "Bracket Destroyed"
  end

  def current_user_bracket_ids
    ids = current_user.brackets.pluck(:id)
    render json: ids.to_json
  end

  private

  def bracket_params
    params.permit(:bracket).permit(:tie_breaker, :name, :points, :possible_points)
  end
end
