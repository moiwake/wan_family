class LikeImagesController < ApplicationController
  before_action :set_blob

  def create
    @like_image = current_user.like_images.create(image_id: params[:image_id], blob_id: params[:blob_id])
    render "create_and_destroy"
  end

  def destroy
    @like_image = LikeImage.find(params[:id])
    @like_image.destroy
    render "create_and_destroy"
  end

  private

  def set_blob
    @blob = ImageBlobsQuery.call(parent_image: params[:image_id]).find(params[:blob_id])
  end
end
