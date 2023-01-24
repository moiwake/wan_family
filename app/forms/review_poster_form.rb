class ReviewPosterForm < FormBase
  attr_accessor :review

  def initialize(attributes: nil, review: Review.new)
    @review = review
    super(attributes: attributes)
  end

  def review_attributes= (attributes)
    review.assign_attributes(attributes)
  end

  def image_attributes= (attributes)
    if review.new_record?
      build_image_record(attributes: attributes, user_id: review.user_id, spot_id: review.spot_id)
    else
      update_iamge_attributes(attributes: attributes)
    end
  end

  private

  def persist
    raise ActiveRecord::RecordInvalid if check_and_add_error
    review.save!
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    return false
  end

  def build_image_record(attributes: nil, user_id: nil, spot_id: nil)
    attributes = attributes.merge({ user_id: review.user_id, spot_id: review.spot_id })
    review.build_image(attributes)
  end

  def update_iamge_attributes(attributes: nil)
    review.image.assign_attributes(attributes)
  end

  def check_and_add_error
    review.invalid? ? add_review_errors : false
  end

  def add_review_errors
    review.errors.each do |error|
      errors.add(:base, error.full_message)
    end
  end

  def default_attributes
    {
      review: review,
    }
  end
end
