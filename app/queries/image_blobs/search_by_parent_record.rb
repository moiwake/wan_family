module ImageBlobs::SearchByParentRecord
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
