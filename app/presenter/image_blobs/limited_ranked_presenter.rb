module ImageBlobs
  class LimitedRankedPresenter
    def self.call(scope: nil, parent_record: nil, limit: nil)
      @scope = ImageBlobs::RankedQuery.call(scope: scope, parent_record: parent_record, rank_num: limit)
      @scope
    end
  end
end
