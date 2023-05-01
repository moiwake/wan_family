class SpotFavoritesController < ApplicationController
  before_action :set_spot

  def create
    @spot_favorite = @spot.spot_favorites.create(user: current_user)
    render "create_and_destroy"
  end

  def destroy
    @spot_favorite = SpotFavorite.find(params[:id])
    @spot_favorite.destroy
    render "create_and_destroy"
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
