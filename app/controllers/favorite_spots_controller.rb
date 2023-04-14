class FavoriteSpotsController < ApplicationController
  before_action :set_spot

  def create
    @favorite_spot = @spot.favorite_spots.create(user: current_user)
    render "create_and_destroy"
  end

  def destroy
    @favorite_spot = FavoriteSpot.find(params[:id])
    @favorite_spot.destroy
    render "create_and_destroy"
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
