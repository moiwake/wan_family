module ImageBlobs::SearchByParentRecord
  def set_searched_blobs_by_parent_record
    blobs = search_image_blobs
    blobs.present? ? blobs : ActiveStorage::Blob.none
  end

  alias_method :set_scope, :set_searched_blobs_by_parent_record

  def search_image_blobs
    if parent_record.present?
      if parent_record.is_a?(Image)
        set_blobs_associated_with_image
      elsif parent_record[0].is_a?(Image)
        set_blobs_associated_with_images
      end
    end
  end

  def set_blobs_associated_with_image
    parent_record.files_blobs
  end

  def set_blobs_associated_with_images
    parent_record.reduce(ActiveStorage::Blob.none) do |image_blobs, image|
      image_blobs.or(image.files_blobs)
    end
  end
end
