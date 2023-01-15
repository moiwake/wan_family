module LikeImageHelper
  def image_liked?(blob)
    current_user.like_images.exists?(blob_id: blob.id) if current_user.present?
  end
end
