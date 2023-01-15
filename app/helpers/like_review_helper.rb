module LikeReviewHelper
  def review_liked?(review)
    current_user.like_reviews.exists?(review_id: review.id) if current_user.present?
  end
end
