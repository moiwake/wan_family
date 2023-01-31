class CreateSpotTags < ActiveRecord::Migration[6.1]
  def change
    create_table :spot_tags do |t|
      t.string :name, null: false, default: "行ってみたい"
      t.string :memo
      t.references :user, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
