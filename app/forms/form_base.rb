class FormBase
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes

  def initialize(attributes: nil)
    attributes ||= default_attributes
    super(attributes)
  end

  def invalid?
    check_and_add_error
  end

  def save
    persist
  end

  private

  def default_attributes
    {}
  end

  def check_and_add_error
    !valid?
  end

  def persist
    true
  end
end
