class UsersController < ApplicationController
  before_action :authenticate_user!

  # mypage
  def index
    @user = current_user
  end

  def spot_index
    @spots = current_user.spots.includes(:category)
  end

  def review_index
    @reviews = current_user.reviews.includes_image.includes(:spot)
  end

  def image_index
    @images = current_user.images.with_attached_files
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
    params.require(:user).permit(:introduction, :avatar)
  end
end
