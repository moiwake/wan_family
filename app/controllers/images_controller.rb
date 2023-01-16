class ImagesController < ApplicationController
  def index
    @spot = Spot.find(params[:spot_id])
    @blobs = ImageBlobsQuery.call(params: params, variant: true)
  end

  def show
    if params[:review_image_only] == "true"
      @blobs = ImageBlobsQuery.call(file_search_condition_hash: { record_id: params[:id] })
      @review_image_only = params[:review_image_only]
    else
      @blobs = ImageBlobsQuery.call(params: params)
    end

    @blob = @blobs.find(params[:blob_id])
    @pre_next_blob_hash = PreNextBlobHash.call(base_blob: @blob, blobs: @blobs, params: params)
    @previous_blob = @pre_next_blob_hash[:previous_blob]
    @next_blob = @pre_next_blob_hash[:next_blob]
  end
end
