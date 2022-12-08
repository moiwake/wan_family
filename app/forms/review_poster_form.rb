class ReviewPosterForm < FormBase
  attr_accessor :review, :image

  def initialize(attributes: nil, review: Review.new, image: nil)
    @review = review
    @image = image
    super(attributes: attributes)
  end

  def review_attributes= (attributes)
    review.assign_attributes(attributes)
  end

  def image_attributes= (attributes)
    if image.nil?
      build_image_record(attributes: attributes, user_id: review.user_id, spot_id: review.spot_id)
    else
      update_iamge_attributes(attributes: attributes)
    end
  end

  private

  def persist
    raise ActiveRecord::RecordInvalid if check_and_add_error

    ActiveRecord::Base.transaction do
      review.save!
      image.save! unless image.nil?
    end

    return true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    return false
  end

  def build_image_record(attributes: nil, user_id: nil, spot_id: nil)
    attributes = attributes.merge({ user_id: user_id, spot_id: spot_id })
    review.image = review.build_image
    review.image.assign_attributes(attributes)
  end

  def update_iamge_attributes(attributes: nil)
    image.assign_attributes(attributes)
  end

  def check_and_add_error
    if review_and_image_invalid?
      add_review_errors
      add_image_errors
      return true
    else
      return false
    end
  end

  def review_and_image_invalid?
    review.invalid? || (review.image.present? ? review.image.invalid? : false)
  end

  def add_review_errors
    review.errors.each do |error|
      errors.add(:base, error.full_message)
    end
  end

  def add_image_errors
    if review.image.present?
      review.image.errors.each do |error|
        errors.add(:base, error.full_message)
      end
    end
  end

  def default_attributes
    {
      review: review,
      image: image,
    }
  end
end