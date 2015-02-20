class HomeController < ApplicationController
  before_filter :ensure_logged_in, only: [:rules, :payments]

  def index
    redirect_to brackets_path if current_user.present?
  end

  def subscribe
    Newsletter.home_page_email(params[:email]).deliver
    redirect_to root_path, notice: "Thank you for your interest. We'll contact you when the beta is ready."
  end

  def rules
  end

  def payments
  end

  protected

  def ensure_logged_in
    if current_user.blank?
      redirect_to root_path
      false
    else
      true
    end
  end
end
