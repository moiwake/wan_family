class UsersController < ApplicationController
  before_action :authenticate_user!

  # mypage
  def index
    @user = current_user
  end

  def spot_index
    @spots = current_user.spots.preload(:category)
  end

  def review_index
    @reviews = OrderedReviewsQuery.call(parent_record: current_user, order_params: params)
  end

  def image_index
    @blobs = OrderedImageBlobsQuery.call(parent_record: current_user.images, order_params: params).preload(attachments: :record)
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
    params.require(:user).permit(:introduction, :human_avatar, :dog_avatar)
  end
end
