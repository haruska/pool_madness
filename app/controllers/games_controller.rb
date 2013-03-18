class GamesController < ApplicationController
  load_and_authorize_resource

  caches_action :index, :layout => false, :cache_path => :index_cache_path.to_proc

  layout 'bracket', :only => 'index'

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @game.update_attributes(params[:game])
      redirect_to games_path, :notice => 'Updated score.'
    else
      render 'edit', :alert => 'Problem updating game.'
    end
  end

  def index_cache_path
    if current_user.has_role?(:admin)
      '/admin/games'
    else
      '/public/games'
    end
  end
end
