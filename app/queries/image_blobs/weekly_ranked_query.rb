module ImageBlobs
  class WeeklyRankedQuery < RankedForSpecificPeriodQuery
    include SearchByParentRecord

    PERIOD_NUMBER = 6

    def initialize(scope:, parent_record:, assessment_class:, date:, number:)
      super(scope: scope, parent_record: parent_record, assessment_class: assessment_class, date: date, number: number)
    end

    def self.call(scope: nil, parent_record: Image.all, assessment_class: "ImageLike", date: "days", number: PERIOD_NUMBER)
      super
    end
  end
end
