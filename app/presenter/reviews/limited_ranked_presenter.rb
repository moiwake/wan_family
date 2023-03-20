module Reviews
  class LimitedRankedPresenter
    def self.call(scope: Review.all, parent_record: nil, limit: nil)
      @scope = Reviews::OrderedQuery.call(scope: scope, parent_record: parent_record, order_params: { by: "like_count" }).limit(limit)
      return @scope
    end
  end
end
