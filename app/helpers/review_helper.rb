module ReviewHelper
  def form_image_saved?(resource)
    resource.review.image.present? && resource.review.image.persisted?
  end
end
