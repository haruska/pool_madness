class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |_exception|
    if user_signed_in?
      flash[:error] = "Not authorized to view this page"
      session[:user_return_to] = nil
      redirect_to root_url

    else
      flash[:info] = "You must first login to view this page"
      session[:user_return_to] = request.url
      redirect_to new_user_session_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end
end
