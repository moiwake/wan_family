class OrderedImageBlobsQuery < OrderedQueryBase
  def initialize(scope:, parent_record:, order_params:, like_class:)
    super(scope: scope, parent_record: parent_record, order_params: order_params, like_class: like_class)
  end

  def self.call(scope: nil, parent_record: Image.all, order_params: {}, like_class: "LikeImage")
    super
  end

  private

  def set_scope
    scope = search_blobs
    return scope.present? ? scope : ActiveStorage::Blob.none
  end

  def search_blobs
    if parent_record.present?
      if parent_record.is_a?(Image)
        set_blobs_associated_with_image
      elsif parent_record[0].is_a?(Image)
        set_blobs_associated_with_images
      end
    end
  end

  def set_blobs_associated_with_image
    parent_record.files.blobs
  end

  def set_blobs_associated_with_images
    parent_record.reduce(ActiveStorage::Blob.none) do |blobs, image|
      blobs = blobs.or(image.files.blobs)
    end
  end
end
