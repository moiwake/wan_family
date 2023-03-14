class CreateRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :regions do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :name_roma, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
