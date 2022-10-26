class RemoveCategoryFromAllowedAreas < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :allowed_areas, :categories
    remove_reference :allowed_areas, :category, index: true
  end
end
