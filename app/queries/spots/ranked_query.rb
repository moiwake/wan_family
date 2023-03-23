module Spots
  class RankedQuery
    RANKING_NUMBER = 10

    def self.call
      Spots::OrderedQuery.call(order_params: { by: "likes_count" }).limit(RANKING_NUMBER)
    end
  end
end
