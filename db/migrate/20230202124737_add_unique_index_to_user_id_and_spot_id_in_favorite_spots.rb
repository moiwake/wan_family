class AddUniqueIndexToUserIdAndSpotIdInFavoriteSpots < ActiveRecord::Migration[6.1]
  def change
    add_index :favorite_spots, [:user_id, :spot_id], unique: true
  end
end
