module Reviews
  class LimitedRankedPresenter
    def self.call(scope: nil, parent_record: nil, limit: nil)
      @scope = Reviews::RankedQuery.call(scope: scope, parent_record: parent_record, rank_num: limit)
      return @scope
    end
  end
end
