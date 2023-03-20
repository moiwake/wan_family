module Reviews
  class OrderedQuery < OrderedQueryBase
    def initialize(scope:, parent_record:, order_params:, like_class:)
      super(scope: scope, parent_record: parent_record, order_params: order_params, like_class: like_class)
    end

    def self.call(scope: Review.all, parent_record: nil, order_params: {}, like_class: "LikeReview")
      super
    end
  end
end
