class AdminBracketsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :pool, only: [:index]

  before_action :load_bracket_and_pool, only: [:mark_paid]
  before_action :auth_pool_admin

  def index
    @brackets = @pool.brackets.includes(:user).to_a.sort_by {|b| [b.user.name, b.name]}
  end

  def mark_paid
    if @bracket.update(payment_collector: current_user)
      @bracket.paid!
      flash[:success] = "Bracket marked paid"
    else
      flash[:error] = "Problem marking bracket paid"
    end

    redirect_to pool_admin_brackets_path(@pool)
  end

  private

  def load_bracket_and_pool
    @bracket = Bracket.find(params[:id])
    @pool = @bracket.pool
  end

  def auth_pool_admin
    raise CanCan::AccessDenied unless can?(:manage, @pool)
  end
end
