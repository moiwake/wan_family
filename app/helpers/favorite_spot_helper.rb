module FavoriteSpotHelper
  def favorite?(spot:)
    current_user.favorite_spots.find_by(spot_id: spot.id).present?
  end
end
