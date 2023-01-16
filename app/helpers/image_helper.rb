module ImageHelper
  def image_link_params_hash(blob:, review_image_only: false)
    params_hash = {
      spot_id: get_parent_image(blob).spot_id,
      id: get_parent_image(blob).id,
      blob_id: blob.id,
      review_image_only: review_image_only
    }

    if params[:by] == "created_at" && params[:direction] == "desc"
      return params_hash.merge({ by: "created_at", direction: "desc" })
    elsif params[:by] == "created_at" && params[:direction] == "asc"
      return params_hash.merge({ by: "created_at", direction: "asc" })
    elsif params[:by] == "likes_count" && params[:direction] == "desc"
      return params_hash.merge({ by: "likes_count", direction: "desc" })
    else
      return params_hash
    end
  end

  def get_parent_image(blob)
    blob.attachments.first.record
  end
end
