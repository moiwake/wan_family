class CreateOptionTitles < ActiveRecord::Migration[6.1]
  def change
    create_table :option_titles do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :option_titles, :name, unique: true
  end
end
