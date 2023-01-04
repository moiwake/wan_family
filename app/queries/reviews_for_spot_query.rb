class ReviewsForSpotQuery
  attr_reader :reviews

  def initialize(reviews: Review.all, search_condition_hash: {})
    @reviews = reviews.where(search_condition_hash)
  end

  def call(params: {})
    reviews_scope = reviews.includes_image.includes(:user, :spot, :likes)

    if params[:column]
      reviews = order_asc_or_desc(reviews_scope, params[:column], params[:direction])
    elsif params[:sort]
      reviews = sort_by_likes(reviews_scope)
    else
      reviews = default_order(reviews_scope)
    end
  end

  private

  def order_asc_or_desc(reviews_scope, column, direction)
    reviews_scope.order({ column => direction })
  end

  def sort_by_likes(reviews_scope)
    reviews_scope.sort{ |a,b| compare_likes_count(higher:b, lower: a) }
  end

  def compare_likes_count(higher:, lower:)
    higher.likes.size <=> lower.likes.size
  end

  def default_order(reviews_scope)
    reviews_scope.order(created_at: :desc)
  end
end
