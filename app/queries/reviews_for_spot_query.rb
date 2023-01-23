class ReviewsForSpotQuery < QueryBase
  class << self
    def call(reviews: Review.all, parent_record: nil, params: {})
      scope = set_default_scope(reviews)
      scope = search_by_parent_record(scope, parent_record)
      order_scope(scope, params)
    end

    private

    def set_default_scope(reviews)
      scope = eager_load_in_scope(reviews)
      scope = preload_in_scope(scope)
      scope = order_blob_record(scope)
    end

    def eager_load_in_scope(scope)
      scope.eager_load(:user, :spot, image: { files_attachments: { blob: :variant_records } })
    end

    def preload_in_scope(scope)
      scope.preload(:like_reviews)
    end

    def order_blob_record(scope)
      scope.order("blob.created_at desc, blob.id desc")
    end

    def search_by_parent_record(scope, parent_record)
      if parent_record.is_a?(User)
        scope.where(user_id: parent_record.id)
      elsif parent_record.is_a?(Spot)
        scope.where(spot_id: parent_record.id)
      end
    end

    def set_ids_in_order_likes
      LikeReview.group(:review_id).order('count(review_id) desc').pluck(:review_id)
    end
  end
end
