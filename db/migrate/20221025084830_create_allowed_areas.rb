class CreateAllowedAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :allowed_areas do |t|
      t.string :area, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :allowed_areas, :area, unique: true
  end
end
