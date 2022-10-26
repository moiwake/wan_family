class RemoveUniqueIndexFromAreaColumnInAllowedAreas < ActiveRecord::Migration[6.1]
  def change
    remove_index :allowed_areas, column: :area
  end
end
