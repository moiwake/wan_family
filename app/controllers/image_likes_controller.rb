class ImageLikesController < ApplicationController
  def create
    @image_like = current_user.image_likes.create(image_id: params[:image_id], blob_id: params[:blob_id])
    set_blob
    render "create_and_destroy"
  end

  def destroy
    @image_like = ImageLike.find(params[:id])
    @image_like.destroy
    set_blob
    render "create_and_destroy"
  end

  private

  def set_blob
    @blob = @image_like.image.files.blobs.preload(attachments: :record).find(params[:blob_id])
  end
end
