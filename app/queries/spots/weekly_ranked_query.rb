module Spots
  class WeeklyRankedQuery < RankedForSpecificPeriodQuery
    RankedForSpecificPeriodQuery::PERIOD_NUMBER = 6

    def self.call(scope: Spot.all, rank_class_scope: FavoriteSpot.all, date: "days", number: PERIOD_NUMBER)
      RankedForSpecificPeriodQuery.call(scope: scope, rank_class_scope: rank_class_scope, date: date, number: number)
    end
  end
end
