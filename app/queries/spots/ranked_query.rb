module Spots
  class RankedQuery
    def self.call(scope: nil, parent_record: nil, rank_num: 10)
      Spots::OrderedQuery.call(scope: scope, parent_record: parent_record, order_params: { by: "likes_count" }).limit(rank_num)
    end
  end
end
