module ImageLikeHelper
  def image_blob_posted_by_another?(image_blob)
    image_blob.attachments[0].record.user_id != current_user.id
  end

  def image_liked?(image_like)
    image_like && image_like.persisted?
  end

  def count_image_blob_likes(image_blob)
    ImageLike.where(blob_id: image_blob.id).size
  end
end
