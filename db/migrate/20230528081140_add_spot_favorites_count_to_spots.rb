class AddSpotFavoritesCountToSpots < ActiveRecord::Migration[6.1]
  def change
    add_column :spots, :spot_favorites_count, :integer, default: 0
  end
end
