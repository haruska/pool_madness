class UsersController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile Updated"
    else
      render :edit
    end
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    authorize! :read, @user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
