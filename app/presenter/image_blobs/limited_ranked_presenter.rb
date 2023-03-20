module ImageBlobs
  class LimitedRankedPresenter
    def self.call(scope: ActiveStorage::Blob.all, parent_record: nil, limit: nil)
      @scope = ImageBlobs::OrderedQuery.call(scope: scope, parent_record: parent_record, order_params: { by: "likes_count" }).limit(limit)
      return @scope
    end
  end
end
