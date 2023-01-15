class ImagesController < ApplicationController
  def index
    @spot = Spot.find(params[:spot_id])
    @blobs = ImageBlobsQuery.call(params: params, variant: true)
  end

  def show
    @blobs = ImageBlobsQuery.call(params: params)
    @blob = @blobs.find(params[:blob_id])
    @pre_next_blob_hash = PreNextBlobHash.call(base_blob: @blob, blobs: @blobs, params: params)
    @previous_blob = @pre_next_blob_hash[:previous_blob]
    @next_blob = @pre_next_blob_hash[:next_blob]
  end
end
