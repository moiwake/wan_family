class Users::MypageController < ApplicationController
  before_action :authenticate_user!

  def favorite_spot_index
    @favorite_spots = Spots::FavoriteByUserQuery.call(user: current_user)
  end

  def spot_tag_index
    @tagged_spots = Spots::TaggedByUserQuery.call(user: current_user)
  end

  def spot_index
    @spots = current_user.spots.preload(:category)
  end

  def review_index
    @reviews = OrderedReviewsQuery.call(parent_record: current_user, order_params: params).load_all_associations
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
      # flash[:notice] = "プロフィールを変更しました。"
      redirect_to mypage_path
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:introduction, :human_avatar, :dog_avatar)
  end
end
