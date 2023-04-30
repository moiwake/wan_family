class ImagesController < ApplicationController
  before_action :set_spot, :set_favorite_spot, :set_tags_user_put_on_spot, only: :index

  def index
    @image_blobs = ImageBlobs::OrderedQuery.call(parent_record: @spot.images, order_params: params)
                  .page(params[:page]).per(Image::PER_PAGE)
                  .preload(attachments: :record)
  end

  def show
    @image = Image.find(params[:id])
    @image_blob = @image.files_blobs.preload(:attachments).find(params[:image_blob_id])

    if current_user.present?
      @image_like = ImageLike.find_by(user_id: current_user.id, blob_id: params[:image_blob_id])
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def set_favorite_spot
    if current_user.present?
      @favorite_spot = current_user.favorite_spots.find_by(spot_id: @spot.id)
    end
  end

  def set_tags_user_put_on_spot
    if current_user.present?
      @tags_user_put_on_spot = SpotTag.get_tags_user_put_on_spot(user_id: current_user.id, spot_id: @spot.id)
    end
  end
end
