class ReviewPosterForm < FormBase
  attr_accessor :review

  def initialize(attributes: nil, review: Review.new)
    @review = review
    super(attributes: attributes, record: review)
  end

  def review_attributes= (attributes)
    review.assign_attributes(attributes)
  end

  def image_attributes= (attributes)
    if review.new_record? || review.image.nil?
      build_image_record(attributes: attributes, user_id: review.user_id, spot_id: review.spot_id)
    else
      update_iamge_attributes(attributes: attributes)
    end
  end

  private

  def build_image_record(attributes: nil, user_id: nil, spot_id: nil)
    attributes = attributes.merge({ user_id: review.user_id, spot_id: review.spot_id })
    review.build_image(attributes)
  end

  def update_iamge_attributes(attributes: nil)
    review.image.assign_attributes(attributes)
  end

  def default_attributes
    {
      review: review,
    }
  end
end
