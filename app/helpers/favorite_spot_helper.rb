module FavoriteSpotHelper
  def favorite?(favorite_spot)
    favorite_spot.present? && favorite_spot.persisted?
  end
end
