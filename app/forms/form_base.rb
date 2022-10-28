class FormBase
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes

  def initialize(attributes: nil)
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    valid? ? persist : false
  rescue ActiveRecord::ActiveRecordError => e
    Rails.logger.error([e.message, *e.backtrace].join($/))
    errors.add(:base, e.message)

    false
  end

  private

  def default_attributes
    {}
  end

  def persist
    true
  end
end
