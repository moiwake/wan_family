class RenameLikesToLikeReviews < ActiveRecord::Migration[6.1]
  def change
    rename_table :likes, :like_reviews
  end
end
