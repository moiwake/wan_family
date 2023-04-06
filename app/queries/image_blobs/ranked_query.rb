module ImageBlobs
  class RankedQuery
    def self.call(rank_num: 10)
      ImageBlobs::OrderedQuery.call(order_params: { by: "likes_count" }).limit(rank_num)
    end
  end
end
