module ImageHelper
  def image_link_params_hash(blob)
    params_hash = {
      spot_id: get_parent_image(blob).spot_id,
      id: get_parent_image(blob).id,
      blob_id: blob.id,
    }

    if params[:column] == "created_at" && params[:direction] == "desc"
      return params_hash.merge({ column: "created_at", direction: "desc" })
    elsif params[:column] == "created_at" && params[:direction] == "asc"
      return params_hash.merge({ column: "created_at", direction: "asc" })
    elsif params[:sort]
      return params_hash.merge({ sort: "likes_count" })
    else
      return params_hash
    end
  end

  def get_parent_image(blob)
    blob.attachments.first.record
  end
end
