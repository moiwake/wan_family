class ImagesController < ApplicationController
  def index
    @spot = Spot.find(params[:spot_id])
    @images = @spot.images
  end
end
