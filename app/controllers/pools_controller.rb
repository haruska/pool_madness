class PoolsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource only: :show

  def index
    @pools = Pool.accessible_by(current_ability)
    redirect_to invite_code_path if @pools.empty?
  end

  def show
    redirect_to pool_brackets_path(@pool)
  end

  def invite_code
  end

  def join
    @pool = Pool.find_by(invite_code: params[:invite_code])

    if @pool.present?
      @pool.users << current_user unless @pool.users.find_by(id: current_user).present?
      flash[:success] = "Successfully joined #{@pool.name} Pool"
      redirect_to pools_path
    else
      flash[:error] = "Invalid code entered"
      redirect_to invite_code_path
    end
  end
end