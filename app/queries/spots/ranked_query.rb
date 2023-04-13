module Spots
  class RankedQuery
    RANK_NUMBER = 10

    class << self
      def call(scope: nil, parent_record: nil, rank_num: RANK_NUMBER)
        limit_scope(Spots::OrderedQuery.call(scope: scope, parent_record: parent_record, order_params: { by: "likes_count" }), rank_num)
      end

      def limit_scope(scope, rank_num)
        scope.limit(rank_num)
      end
    end
  end
end
