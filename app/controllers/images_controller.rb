class ImagesController < ApplicationController
  def index
    @spot = Spot.includes_images.find(params[:spot_id])
    @images = @spot.images
  end
end
