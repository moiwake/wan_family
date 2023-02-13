class ImagesController < ApplicationController
  def index
    @spot = Spot.find(params[:spot_id])
    @blobs = OrderedImageBlobsQuery.call(parent_image: @spot.images, order_params: params, variant: true)
  end

  def show
    @blob = ActiveStorage::Blob.preload(attachments: :record).find(params[:blob_id])

    if current_user.present?
      @like_image = LikeImage.find_by(user_id: current_user.id, blob_id: params[:blob_id])
    end
  end
end
