class BracketsController < ApplicationController
  load_and_authorize_resource

  def create
    if @bracket.save
      redirect_to edit_bracket_path(@bracket)
    else
      redirect_to root_path, :alert => 'Problem creating a new bracket. Please try again.'
    end
  end

  def destroy
    @bracket.destroy
    redirect_to root_path, :notice => 'Bracket Destroyed'
  end
end
