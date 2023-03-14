module Spots
  class RankedQuery < RankedQueryBase
    def self.call(scope: Spot.all, parent_record: nil, rank_class_record: FavoriteSpot.all)
      RankedQueryBase.call(scope: scope, parent_record: parent_record, rank_class_record: rank_class_record)
    end
  end
end
