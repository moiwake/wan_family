class AddUniqueIndexToUserIdAndBlobIdInLikeImages < ActiveRecord::Migration[6.1]
  def change
    add_index :like_images, [:user_id, :blob_id], unique: true
  end
end
