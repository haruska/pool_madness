class PoolsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def index

  end

  def show
    redirect_to pool_brackets_path(@pool)
  end
end