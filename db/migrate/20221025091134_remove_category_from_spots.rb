class RemoveCategoryFromSpots < ActiveRecord::Migration[6.1]
  def change
    remove_column :spots, :category
  end
end
