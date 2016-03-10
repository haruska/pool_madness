class HomeController < ApplicationController
  before_action :check_authentication, only: :index

  caches_action :index

  def index
  end

  def subscribe
    Newsletter.home_page_email(params[:email]).deliver_later
    redirect_to root_path, notice: "Thank you for your interest. We'll contact you when the beta is ready."
  end

  private

  def check_authentication
    redirect_to pools_path if current_user.present?
  end
end
