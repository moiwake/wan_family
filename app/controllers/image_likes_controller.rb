class ImageLikesController < ApplicationController
  def create
    @image_like = current_user.image_likes.create(image_id: params[:image_id], image_blob_id: params[:image_blob_id])
    set_image_blob
    render "create_and_destroy"
  end

  def destroy
    @image_like = ImageLike.find(params[:id])
    @image_like.destroy
    set_image_blob
    render "create_and_destroy"
  end

  private

  def set_image_blob
    @image_blob = @image_like.image.files_blobs.preload(attachments: :record).find(params[:image_blob_id])
  end
end
