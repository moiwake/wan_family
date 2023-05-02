class Users::MypageController < ApplicationController
  before_action :authenticate_user!

  def spot_favorite_index
    @spot_favorites = Spots::FavoriteByUserQuery.call(user: current_user).
      page(params[:page]).
      preload(:category)
  end

  def spot_tag_index
    @tagged_spots = Spots::TaggedByUserQuery.call(user: current_user, tag_params: params).
      page(params[:page]).
      preload(:category)
    @tag_names = SpotTag.get_tag_names_user_created(user_id: current_user.id)
  end

  def spot_index
    @spots = Spots::OrderedQuery.call(scope: current_user.spots, order_params: params).
      page(params[:page]).
      preload(:category)
  end

  def review_index
    @reviews = Reviews::OrderedQuery.call(parent_record: current_user, order_params: params).
      page(params[:page]).
      load_all_associations
  end

  def image_index
    @image_blobs = ImageBlobs::OrderedQuery.call(parent_record: current_user.images, order_params: params).
      page(params[:page]).per(Image::PER_PAGE).
      preload(attachments: :record)
  end

  # profile
  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user

    if @user.update(user_params)
      flash[:notice] = "プロフィールを変更しました。"
      redirect_to users_mypage_spot_favorite_index_path
    else
      render "edit_profile"
    end
  end

  private

  def user_params
    params.require(:user).permit(:introduction, :human_avatar, :dog_avatar)
  end
end
