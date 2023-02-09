class ImageBlobsQuery < QueryBase
  class << self
    def call(blobs: ActiveStorage::Blob.all, parent_image: Image.all, variant: false, order_params: {})
      files = set_files(parent_image)
      scope = set_default_scope(blobs, files)
      scope = preload_variant_record(scope, variant)
      order_scope(scope, order_params)
    end

    private

    def set_files(parent_image)
      files = ActiveStorage::Attachment.where(record_type: "Image")
      search_by_parent_image(files, parent_image)
    end

    def search_by_parent_image(files, parent_image)
      if parent_image.nil?
        return []
      else
        parent_image_id = [].push(parent_image).flatten.pluck(:id)
        return files.where(record_id: parent_image_id)
      end
    end

    def set_default_scope(scope, files)
      preloaded_scope = preload_attachments_and_record(scope)
      preloaded_scope.where(id: files.pluck(:blob_id))
    end

    def preload_attachments_and_record(scope)
      scope.preload(attachments: :record)
    end

    def preload_variant_record(scope, variant)
      variant ? scope.preload(:variant_records) : scope
    end

    def set_ids_in_order_likes
      LikeImage.group(:blob_id).order('count(blob_id) desc').pluck(:blob_id)
    end
  end
end
