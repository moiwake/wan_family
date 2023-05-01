class ChangeFavoriteSpotsToSpotFavorites < ActiveRecord::Migration[6.1]
  def change
    rename_table :favorite_spots, :spot_favorites
  end
end
