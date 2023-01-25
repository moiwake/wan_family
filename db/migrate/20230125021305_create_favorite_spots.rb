class CreateFavoriteSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_spots do |t|
      t.references :user, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
