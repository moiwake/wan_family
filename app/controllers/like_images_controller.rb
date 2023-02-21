class LikeImagesController < ApplicationController
  def create
    @like_image = current_user.like_images.create(image_id: params[:image_id], blob_id: params[:blob_id])
    set_blob
    render "create_and_destroy"
  end

  def destroy
    @like_image = LikeImage.find(params[:id])
    @like_image.destroy
    set_blob
    render "create_and_destroy"
  end

  private

  def set_blob
    @blob = @like_image.image.files.blobs.preload(attachments: :record).find(params[:blob_id])
  end
end
