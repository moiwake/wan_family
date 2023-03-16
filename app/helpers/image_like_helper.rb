module ImageLikeHelper
  def image_posted_by_another?(blob)
    blob.attachments[0].record.user_id != current_user.id
  end

  def image_liked?(image_like)
    image_like && image_like.persisted?
  end

  def count_image_like(blob)
    ImageLike.where(blob_id: blob.id).size
  end
end
