module Spots
  class RankedQuery < RankedQueryBase
    def initialize(scope:, parent_record:, order_params:, assessment_class:, rank_num:)
      super(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class, rank_num: rank_num)
    end

    def self.call(scope: Spot.all, parent_record: nil, assessment_class: "SpotFavorite", rank_num: RANK_NUMBER)
      super
    end
  end
end
