module Reviews
  class LimitedRankedPresenter
    def self.call(scope: nil, parent_record: nil, limit: nil)
      Reviews::RankedQuery.call(scope: scope, parent_record: parent_record, rank_num: limit)
    end
  end
end
