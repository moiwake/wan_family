class ReviewsForSpotQuery < QueryBase
  class << self
    def call(reviews: Review.all, search_condition_hash: {}, params: {})
      scope = set_default_scope(reviews).where(search_condition_hash)
      order_scope(scope, params)
    end

    private

    def set_default_scope(reviews)
      reviews.includes_image.includes(:user, :spot, :like_reviews)
    end

    def set_ids_in_order_likes
      LikeReview.group(:review_id).order('count(review_id) desc').pluck(:review_id)
    end
  end
end
