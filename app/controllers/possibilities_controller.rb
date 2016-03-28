class PossibilitiesController < ApplicationController
  load_and_authorize_resource :pool

  before_action :check_num_games_remaining

  def show
    @outcome_set = PossibleOutcomeSet.new(tournament: tournament, exclude_eliminated: true)
  end

  private

  def tournament
    @pool.tournament
  end

  def check_num_games_remaining
     redirect_to(pool_brackets_path) unless tournament.num_games_remaining.between?(1, 3)
  end
end
