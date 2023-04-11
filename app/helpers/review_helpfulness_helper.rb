module ReviewHelpfulnessHelper
  def review_posted_by_another?(review)
    review.user_id != current_user.id
  end

  def review_helpful?(review_helpfulness)
    review_helpfulness.present? && review_helpfulness.persisted?
  end

  def review_helpfulness_by_user(review)
    if current_user.present?
      ReviewHelpfulness.find_by(user_id: current_user.id, review_id: review.id)
    end
  end
end
