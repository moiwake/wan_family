module Spots
  class WeeklyRankedQuery < RankedForSpecificPeriodQuery
    RankedForSpecificPeriodQuery::PERIOD_NUMBER = 6

    def initialize(scope:, parent_record:, like_class:, date:, number:)
      super(scope: scope, parent_record: parent_record, like_class: like_class, date: date, number: number)
    end

    def self.call(scope: Spot.all, parent_record: nil, like_class: "FavoriteSpot", date: "days", number: PERIOD_NUMBER)
      super
    end
  end
end
