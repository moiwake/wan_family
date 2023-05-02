module ImageBlobs
  class WeeklyRankedQuery < RankedForSpecificPeriodQuery
    include SearchByParentRecord

    PERIOD_NUMBER = 6

    def initialize(scope:, parent_record:, like_class:, date:, number:)
      super(scope: scope, parent_record: parent_record, like_class: like_class, date: date, number: number)
    end

    def self.call(scope: nil, parent_record: Image.all, like_class: "ImageLike", date: "days", number: PERIOD_NUMBER)
      super
    end

    private

    def set_scope
      scope = search_image_blobs
      scope.present? ? scope : ActiveStorage::Blob.none
    end
  end
end
