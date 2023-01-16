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
    @prev_next_blob_hash = PrevNextBlobHash.call(base_blob: @blob, blobs: @blobs, params: params)
    @prev_blob = @prev_next_blob_hash[:prev_blob]
    @next_blob = @prev_next_blob_hash[:next_blob]
  end
end
