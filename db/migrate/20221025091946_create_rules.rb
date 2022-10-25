class CreateRules < ActiveRecord::Migration[6.1]
  def change
    create_table :rules do |t|
      t.references :spot, null: false, foreign_key: true
      t.references :rule_option, null: false, foreign_key: true
      t.string :answer, null: false, default: false

      t.timestamps
    end
  end
end
