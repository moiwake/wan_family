class ImageBlobsQuery < QueryBase
  class << self
    def call(blobs: ActiveStorage::Blob.all, parent_images: nil, parent_spots: nil, variant: false, order_params: {})
      files = set_files(parent_images, parent_spots)
      scope = set_default_scope(blobs, files)
      scope = with_variant_record(scope) if variant
      order_scope(scope, order_params)
    end

    private

    def set_files(parent_images, parent_spots)
      files = ActiveStorage::Attachment.where(record_type: "Image")

      if parent_images || parent_spots
        files = search_files(files, parent_images, parent_spots)
      end

      return files
    end

    def set_default_scope(blobs, files)
      blobs.preload(attachments: :record).where(id: files.pluck(:blob_id))
    end

    def with_variant_record(scope)
      scope.includes(:variant_records)
    end

    def set_ids_in_order_likes
      LikeImage.group(:blob_id).order('count(blob_id) desc').pluck(:blob_id)
    end

    def search_files(files, parent_images, parent_spots)
      parent_image_ids = []

      if parent_images
        parent_image_ids << parent_images.pluck(:id)
      end

      if parent_spots
        parent_spot_ids = parent_spots.pluck(:id)
        parent_image_ids << Image.where(spot_id: parent_spot_ids).pluck(:id)
      end

      return files.where(record_id: parent_image_ids.flatten)
    end
  end
end
