class BlobsForRankQuery < ForRankQueryBase
  def initialize(scope:, rank_class:)
    super(scope: scope, rank_class: rank_class)
  end

  def self.call(scope: ActiveStorage::Blob.all, rank_class: "LikeImage")
    super
  end
end
