module LikeImageHelper
  def image_liked?(blob)
    current_user.like_images.exists?(blob_id: blob.id) if current_user.present?
  end

  def get_image_likes_count(blob)
    LikeImage.where(blob_id: blob.id).size
  end
end
