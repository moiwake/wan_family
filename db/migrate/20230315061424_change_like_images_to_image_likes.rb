class ChangeLikeImagesToImageLikes < ActiveRecord::Migration[6.1]
  def change
    rename_table :like_images, :image_likes
  end
end
