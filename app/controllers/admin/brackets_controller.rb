class Admin::BracketsController < ApplicationController
  before_filter :ensure_admin

  def index
    if params[:payment_state]
      @brackets = Bracket.where(:payment_state => params[:payment_state]).all
    else
      @brackets = Bracket.all
    end
  end

  def mark_paid
    @bracket = Bracket.find(params[:id])

    @bracket.payment_collector = current_user
    @bracket.save!

    @bracket.payment_received!

    redirect_to admin_brackets_path, :notice => "Bracket #{@bracket.name} marked paid"
  end

  def promise_to_pay
    @bracket = Bracket.find(params[:id])

    @bracket.payment_collector = current_user
    @bracket.save!

    @bracket.promise_made!

    redirect_to admin_brackets_path, :notice => "Bracket #{@bracket.name} marked promised to pay"
  end

  private

  def ensure_admin
    unless current_user.has_role? :admin
      render :nothing => true, :status => 404
      false
    end
    true
  end
end
