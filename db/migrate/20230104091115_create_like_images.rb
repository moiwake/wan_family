class CreateLikeImages < ActiveRecord::Migration[6.1]
  def change
    create_table :like_images do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :image,   null: false, foreign_key: true
      t.integer    :blob_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
