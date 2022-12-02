module ImagesHelper
  def present_and_attached?(image)
    image.present? && image.files.attached?
  end
end
