class CreatePrefectures < ActiveRecord::Migration[6.1]
  def change
    create_table :prefectures do |t|
      t.string :name, null: false, index: { unique: true, name: 'unique_names' }
      t.string :name_roma, null: false, index: { unique: true, name: 'unique_name_romas' }
      t.string :region, null: false
      t.string :region_roma, null: false

      t.timestamps
    end
  end
end
