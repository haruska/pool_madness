class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
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

end
