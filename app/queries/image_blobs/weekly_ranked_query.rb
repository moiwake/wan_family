module ImageBlobs
  class WeeklyRankedQuery < RankedForSpecificPeriodQuery
    RankedForSpecificPeriodQuery::PERIOD_NUMBER = 6

    def initialize(scope:, parent_record:, like_class:, date:, number:)
      super(scope: scope, parent_record: parent_record, like_class: like_class, date: date, number: number)
    end

    def self.call(scope: nil, parent_record: Image.all, like_class: "ImageLike", date: "days", number: PERIOD_NUMBER)
      super
    end

    private

    def set_scope
      scope = search_image_blobs
      return scope.present? ? scope : ActiveStorage::Blob.none
    end

    def search_image_blobs
      if parent_record.present?
        if parent_record.is_a?(Image)
          set_blobs_associated_with_image
        elsif parent_record[0].is_a?(Image)
          set_blobs_associated_with_images
        end
      end
    end

    def set_blobs_associated_with_image
      parent_record.files_blobs
    end

    def set_blobs_associated_with_images
      parent_record.reduce(ActiveStorage::Blob.none) do |image_blobs, image|
        image_blobs = image_blobs.or(image.files_blobs)
      end
    end
  end
end
