class ImageBlobsQuery < QueryBase
  class << self
    def call(blobs: ActiveStorage::Blob.all, parent_image: [], variant: false, order_params: {})
      files = set_files(parent_image)
      scope = set_default_scope(blobs, files)
      scope = with_variant_record(scope) if variant
      order_scope(scope, order_params)
    end

    private

    def set_files(parent_image)
      files = ActiveStorage::Attachment.where(record_type: "Image")
      search_by_parent_image(files, parent_image)
    end

    def set_default_scope(blobs, files)
      blobs.preload(attachments: :record).where(id: files.pluck(:blob_id))
    end

    def with_variant_record(scope)
      scope.preload(:variant_records)
    end

    def set_ids_in_order_likes
      LikeImage.group(:blob_id).order('count(blob_id) desc').pluck(:blob_id)
    end

    def search_by_parent_image(files, parent_image)
      if parent_image.nil?
        []
      elsif parent_image.is_a?(Image)
        parent_image_id = parent_image.id
      elsif parent_image[0].is_a?(Image)
        parent_image_id = parent_image.pluck(:id)
      elsif parent_image.is_a?(String)
        parent_image_id = parent_image
      end

      return files.where(record_id: parent_image_id)
    end
  end
end
