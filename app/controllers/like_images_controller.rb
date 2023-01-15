class LikeImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_spot

  def create
    @like_image = current_user.like_images.create(image_id: params[:image_id], blob_id: params[:blob_id])
    set_blob(params[:blob_id])
    render "create_and_destroy"
  end

  def destroy
    @like_image = LikeImage.find_by(blob_id: params[:id])
    @like_image.destroy
    set_blob(params[:id])
    render "create_and_destroy"
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def set_blob(params_blob_id)
    @blob = Image.find(params[:image_id]).files.blobs.find(params_blob_id)
  end
end
