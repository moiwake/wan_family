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

  def review_helpfulness_btn_path(review, review_helpfulness)
    if current_user.present?
      if review_posted_by_another?(review)
        if review_helpful?(review_helpfulness)
          { href: spot_review_review_helpfulness_path(review.spot, review, review_helpfulness), method: :delete, class: "review-helpfulness-remove-btn", remote: true }
        else
          { href: spot_review_review_helpfulnesses_path(review.spot, review), method: :post, class: "review-helpfulness-add-btn", remote: true }
        end
      end
    else
      { href: new_user_session_path, class: "sign-in-btn" }
    end
  end
end
