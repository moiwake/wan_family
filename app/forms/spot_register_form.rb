class SpotRegisterForm < FormBase
  attr_accessor :spot, :rules

  def initialize(attributes: nil, spot: Spot.new, rules: nil)
    @spot = spot
    @rules = rules
    super(attributes: attributes)
  end

  def spot_attributes= (attributes)
    spot.assign_attributes(attributes)
  end

  def rules_attributes= (attributes)
    attributes.each do |key, value|
      if rules.nil?
        value.transform_keys(&:to_sym)
        build_rule_records(rule_option_id: key, answer: value[:answer])
      else
        update_rules_attributes(rule_option_id: key, attributes: value)
      end
    end
  end

  private

  def persist
    ActiveRecord::Base.transaction do
      spot.save!
      spot.rule.each(&:save!)
    end

    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end

  def build_rule_records(rule_option_id: nil, answer: nil)
    spot.rule.build(rule_option_id: rule_option_id, answer: answer)
  end

  def update_rules_attributes(rule_option_id: nil, attributes: nil)
    rules.each do |r|
      if r.rule_option_id.to_s == rule_option_id
        r.assign_attributes(attributes)
      end
    end
  end

  def check_and_add_error
    spot_and_rule_invalid? ? add_spot_errors : false
  end

  def spot_and_rule_invalid?
    spot.invalid? || spot.rule.map(&:invalid?).include?(true)
  end

  def add_spot_errors
    delete_errors_not_to_display
    spot.errors.each do |error|
      errors.add(:base, error.full_message)
    end
  end

  def delete_errors_not_to_display
    if spot.errors[:address].present?
      spot.errors.delete(:latitude)
      spot.errors.delete(:longitude)
    end
  end

  def default_attributes
    {
      spot: spot,
      rules: rules,
    }
  end
end
