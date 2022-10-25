class RemoveAllowedAreaFromSpots < ActiveRecord::Migration[6.1]
  def change
    remove_column :spots, :allowed_area
  end
end
