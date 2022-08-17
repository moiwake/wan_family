class UsersController < ApplicationController
  # mypage
  def index
    @user = current_user
  end

  # profile
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      flash[:notice] = "プロフィールを変更しました。"
      redirect_to edit_profile_path
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_introduction, :avatar)
  end
end
