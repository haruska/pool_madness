class PoolsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource only: :show

  def index
    @pools = Pool.accessible_by(current_ability)
  end

  def show
    redirect_to pool_brackets_path(@pool)
  end
end