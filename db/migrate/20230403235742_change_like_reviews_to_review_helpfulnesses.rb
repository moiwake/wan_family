class ChangeLikeReviewsToReviewHelpfulnesses < ActiveRecord::Migration[6.1]
  def change
    rename_table :like_reviews, :review_helpfulnesses
  end
end
