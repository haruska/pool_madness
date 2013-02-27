class BracketsController < ApplicationController
  load_and_authorize_resource

  def create
    if @bracket.save
      redirect_to edit_bracket_path(@bracket)
    else
      redirect_to root_path, :alert => 'Problem creating a new bracket. Please try again.'
    end
  end

  def update
    if @bracket.update_attributes(params[:bracket])
      flash[:notice] = "Thank you. Your bitcoin payment is being processed." if params[:bracket][:pending_payment]
      render :nothing => true
    else
      render :nothing => true, :status => 400
    end
  end

  def destroy
    @bracket.destroy
    redirect_to root_path, :notice => 'Bracket Destroyed'
  end
end
