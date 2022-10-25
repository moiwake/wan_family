class CreateSpotHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :spot_histories do |t|
      t.references :spot, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :history, null: false

      t.timestamps
    end
  end
end
