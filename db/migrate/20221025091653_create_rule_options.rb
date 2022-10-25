class CreateRuleOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :rule_options do |t|
      t.string :name, null: false
      t.references :option_title, null: false, foreign_key: true

      t.timestamps
    end

    add_index :rule_options, :name, unique: true
  end
end
