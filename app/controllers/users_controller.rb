class UsersController < ApplicationController
  before_filter :authenticate_user!

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile Updated"
    else
      redirect_to edit_profile_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
