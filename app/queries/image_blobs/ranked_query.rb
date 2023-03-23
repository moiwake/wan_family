module ImageBlobs
  class RankedQuery
    RANKING_NUMBER = 10

    def self.call
      ImageBlobs::OrderedQuery.call(order_params: { by: "likes_count" }).limit(RANKING_NUMBER)
    end
  end
end
