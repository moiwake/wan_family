class FormBase
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes

  attr_reader :record

  def initialize(attributes: nil, record: nil)
    @record = record
    attributes ||= default_attributes
    super(attributes)
  end

  def invalid?
    check_and_add_errors
  end

  def save
    persist
  end

  private

  def default_attributes
    {}
  end

  def check_and_add_errors
    record.invalid? ? add_errors : false
  end

  def add_errors
    record.errors.each do |error|
      errors.add(:base, error.full_message)
    end
  end

  def persist
    raise ActiveRecord::RecordInvalid if check_and_add_errors
    record.save!
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end
end
