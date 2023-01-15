class ImageBlobsQuery < QueryBase
  class << self
    def call(blobs: ActiveStorage::Blob.all, file_search_condition_hash: {}, blob_search_condition_hash: {}, variant: false, params: {})
      files = set_default_files.where(file_search_condition_hash)
      scope = set_default_scope(blobs, files).where(blob_search_condition_hash)

      if variant
        scope = scope.includes(:variant_records)
      end

      order_scope(scope, params)
    end

    private

    def set_default_scope(blobs, files)
      blobs.preload(attachments: :record).where(id: files.pluck(:blob_id))
    end

    def set_default_files
      ActiveStorage::Attachment.where(record_type: "Image")
    end

    def set_ids_in_order_likes
      LikeImage.group(:blob_id).order('count(blob_id) desc').pluck(:blob_id)
    end
  end
end
