class OrderedReviewsQuery < OrderedQueryBase
  def initialize(scope:, parent_record:, order_params:, like_class:)
    super(scope: scope, parent_record: parent_record, order_params: order_params, like_class: like_class)
  end

  def self.call(scope: Review.all, parent_record: nil, order_params: {}, like_class: "LikeReview")
    super
  end

  private

  def set_scope
    if parent_record.nil?
      scope
    elsif parent_record.is_a?(User)
      scope.where(user_id: parent_record.id)
    elsif parent_record.is_a?(Spot)
      scope.where(spot_id: parent_record.id)
    end
  end
end
