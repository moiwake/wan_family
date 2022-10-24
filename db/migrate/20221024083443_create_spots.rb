class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.string :name,         null: false
      t.float  :latitude,     null: false, limit: 53
      t.float  :longitude,    null: false, limit: 53
      t.string :address,      null: false
      t.string :category,     null: false
      t.string :allowed_area, null: false
      t.text   :official_site

      t.timestamps
    end

    add_index :spots, :address               , unique: true
    add_index :spots, [:latitude, :longitude], unique: true
  end
end
