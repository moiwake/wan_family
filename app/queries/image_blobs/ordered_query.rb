module ImageBlobs
  class OrderedQuery < OrderedQueryBase
    def initialize(scope:, parent_record:, order_params:, like_class:)
      super(scope: scope, parent_record: parent_record, order_params: order_params, like_class: like_class)
    end

    def self.call(scope: nil, parent_record: nil, order_params: {}, like_class: "ImageLike")
      parent_record ||= Image.all
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
