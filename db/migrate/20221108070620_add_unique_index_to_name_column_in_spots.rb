class AddUniqueIndexToNameColumnInSpots < ActiveRecord::Migration[6.1]
  def change
    add_index :spots, :name, unique: true
  end
end
