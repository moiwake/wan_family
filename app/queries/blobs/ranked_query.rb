module Blobs
  class RankedQuery < RankedQueryBase
    def self.call(scope: ActiveStorage::Blob.all, parent_record: Image.all, rank_class_record: LikeImage.all)
      RankedQueryBase.call(scope: scope, parent_record: parent_record, rank_class_record: rank_class_record)
    end
  end
end
