class ImageLikesController < ApplicationController
  before_action :set_image_blob

  def create
    @image_like = @image.image_likes.create(user: current_user, blob_id: params[:image_blob_id])
    render "create_and_destroy"
  end

  def destroy
    @image_like = ImageLike.find(params[:id])
    @image_like.destroy
    render "create_and_destroy"
  end

  private

  def set_image_blob
    @image = Image.find(params[:image_id])
    @image_blob = @image.files_blobs.preload(:attachments).find(params[:image_blob_id])
  end
end
