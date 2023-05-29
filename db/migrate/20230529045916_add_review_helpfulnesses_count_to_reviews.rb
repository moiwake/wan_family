class AddReviewHelpfulnessesCountToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :review_helpfulnesses_count, :integer, default: 0
  end
end
