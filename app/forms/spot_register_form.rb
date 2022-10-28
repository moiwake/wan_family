class SpotRegisterForm < FormBase
  attr_accessor :spot, :rules

  delegate :spot_histories, to: :spot

  def initialize(attributes: nil, spot: Spot.new)
    @spot = spot
    super(attributes: attributes)
  end

  def spot_attributes= (attributes)
    spot.assign_attributes(attributes)
  end

  def rule_attributes= (attributes)
    @rules = []
    attributes["answer"].each do |key, value|
      @rules << spot.rule.build(rule_option_id: key, answer: value)
    end
  end

  private

  def persist
    raise ActiveRecord::RecordInvalid unless spot.valid?
    spot.save

    raise ActiveRecord::RecordInvalid unless rules.each { |r| r.valid? }
    rules.each(&:save)

    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    errors_form_spot
    false
  end

  def errors_form_spot
    errors_not_to_display
    spot.errors.each do |error|
      errors.add(:base, error.full_message)
    end
  end

  def errors_not_to_display
    if spot.errors[:address]
      spot.errors.delete(:latitude)
      spot.errors.delete(:longitude)
    end
  end
end

