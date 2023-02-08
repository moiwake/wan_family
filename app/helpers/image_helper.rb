module ImageHelper
  def image_link_params_hash(blob)
    params_hash = {
      spot_id: get_parent_image(blob).spot_id,
      id: get_parent_image(blob).id,
      blob_id: blob.id,
    }
  end

  def get_parent_image(blob)
    blob.attachments.first.record
  end
end
