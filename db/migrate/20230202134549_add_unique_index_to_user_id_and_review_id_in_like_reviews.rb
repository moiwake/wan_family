class AddUniqueIndexToUserIdAndReviewIdInLikeReviews < ActiveRecord::Migration[6.1]
  def change
    add_index :like_reviews, [:user_id, :review_id], unique: true
  end
end
