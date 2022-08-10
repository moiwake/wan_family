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
      flash[:notice] = "プロフィール情報を変更しました。"
      redirect_to profile_edit_path
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_introduction, :avator)
  end
end
