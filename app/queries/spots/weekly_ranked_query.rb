module Spots
  class WeeklyRankedQuery < RankedForSpecificPeriodQuery
    PERIOD_NUMBER = 6

    def initialize(scope:, parent_record:, assessment_class:, date:, number:)
      super(scope: scope, parent_record: parent_record, assessment_class: assessment_class, date: date, number: number)
    end

    def self.call(scope: Spot.all, parent_record: nil, assessment_class: "Impression", date: "days", number: PERIOD_NUMBER)
      super
    end

    def set_assessment_class_foreign_key
      @assessment_class_foreign_key = "impressionable_id"
    end
  end
end
