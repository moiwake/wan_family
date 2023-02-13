class OrderedReviewsQuery < OrderedQueryBase
  class << self
    def call(reviews: Review.all, parent_record: nil, order_params: {})
      scope = set_default_scope(reviews)
      scope = search_by_parent_record(scope, parent_record)
      order_scope(scope, order_params)
    end

    private

    def set_default_scope(scope)
      preload_like_reviews(eager_load_associations(scope))
    end

    def eager_load_associations(scope)
      scope.eager_load(:user, :spot, image: { files_attachments: { blob: :variant_records } }).distinct
    end

    def preload_like_reviews(scope)
      scope.preload(:like_reviews)
    end

    def search_by_parent_record(scope, parent_record)
      if parent_record.nil?
        return scope
      elsif parent_record.is_a?(User)
        return scope.where(user_id: parent_record.id)
      elsif parent_record.is_a?(Spot)
        return scope.where(spot_id: parent_record.id)
      end
    end

    def set_ids_in_order_likes
      LikeReview.group(:review_id).order('count(review_id) desc').pluck(:review_id)
    end
  end
end
