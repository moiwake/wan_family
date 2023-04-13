module ImageBlobs
  class OrderedQuery < OrderedQueryBase
    include SearchByParentRecord

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
  end
end
