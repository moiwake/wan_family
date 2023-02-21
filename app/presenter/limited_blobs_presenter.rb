class LimitedBlobsPresenter
  attr_reader :blobs, :parent_image, :limit

  MAX_DISPLAY_NUMBER = 5.freeze

  def initialize(parent_image:, limit:)
    @parent_image = parent_image
    @limit = limit
  end

  def self.call(parent_image: nil, limit: MAX_DISPLAY_NUMBER)
    @blobs = new(parent_image: parent_image, limit: limit).set_limited_blobs
    return @blobs
  end

  def set_limited_blobs
    @blobs = set_ordered_blobs
    @blobs = limit_blobs
  end

  private

  def set_ordered_blobs
    OrderedImageBlobsQuery.call(parent_record: parent_image)
  end

  def limit_blobs
    blobs.limit(limit)
  end
end
