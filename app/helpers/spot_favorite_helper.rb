module SpotFavoriteHelper
  def favorite?(spot_favorite)
    spot_favorite.present? && spot_favorite.persisted?
  end
end
