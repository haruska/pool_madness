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
    status = 200

    if params[:bracket][:pending_payment]
      @bracket.bitcoin_payment_submited!
      flash[:notice] = "Thank you. Your bitcoin payment is being processed."
    elsif !@bracket.update_attributes(params[:bracket])
      status = 400
    end

    render :nothing => true, :status => status
  end

  def destroy
    @bracket.destroy
    redirect_to root_path, :notice => 'Bracket Destroyed'
  end

end
