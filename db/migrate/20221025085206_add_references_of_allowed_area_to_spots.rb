class AddReferencesOfAllowedAreaToSpots < ActiveRecord::Migration[6.1]
  def change
    add_reference :spots, :allowed_area, null: false, foreign_key: true
  end
end
