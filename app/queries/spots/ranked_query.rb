module Spots
  class RankedQuery
    def self.call(rank_num: 10)
      Spots::OrderedQuery.call(order_params: { by: "likes_count" }).limit(rank_num)
    end
  end
end
