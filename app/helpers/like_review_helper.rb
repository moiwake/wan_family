module LikeReviewHelper
  def review_posted_by_another?(review)
    review.user_id != current_user.id
  end

  def review_liked?(review)
    current_user.present? && current_user.like_reviews.exists?(review_id: review.id)
  end
end
