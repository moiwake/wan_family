class AddUniqueIndexToAreaColumnInAllowedAreas < ActiveRecord::Migration[6.1]
  def change
    add_index :allowed_areas, :area, unique: true
  end
end
