class FavoriteSpotsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_spot

  def create
    @favorite_spot = current_user.favorite_spots.create(spot_id: params[:spot_id])
    set_spot
    render "create_and_destroy"
  end

  def destroy
    @favorite_spot = FavoriteSpot.find(params[:id])
    set_spot
    @favorite_spot.destroy
    render "create_and_destroy"
  end

  private

  def set_spot
    @spot = @favorite_spot.spot
  end
end
