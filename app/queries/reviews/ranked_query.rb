module Reviews
  class RankedQuery
    def self.call(scope: nil, parent_record: nil, rank_num: 10)
      Reviews::OrderedQuery.call(scope: scope, parent_record: parent_record, order_params: { by: "likes_count" }).limit(rank_num)
    end
  end
end
