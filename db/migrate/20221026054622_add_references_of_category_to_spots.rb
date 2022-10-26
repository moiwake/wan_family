class AddReferencesOfCategoryToSpots < ActiveRecord::Migration[6.1]
  def change
    add_reference :spots, :category, null: false, foreign_key: true
  end
end
