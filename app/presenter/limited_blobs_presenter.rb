class LimitedBlobsPresenter
  attr_reader :blobs, :parent_record, :limit

  def initialize(blobs:, parent_record:, limit:)
    @blobs = blobs
    @parent_record = parent_record
    @limit = limit
  end

  def self.call(blobs: nil, parent_record:, limit: nil)
    @blobs = new(blobs: blobs, parent_record: parent_record, limit: limit).limit_blobs
    return @blobs
  end

  def limit_blobs
    set_blobs.limit(limit)
  end

  private

  def set_blobs
    @blobs = Blobs::RankedQuery.call(parent_record: parent_record)
  end
end
