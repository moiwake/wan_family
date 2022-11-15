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

  def rule_attributes= (attributes)
    attributes["answer"].each do |key, value|
      unless rules.nil?
        rules.each do |r|
          if r.rule_option_id.to_s == key
            r.attributes = { answer: value }
          end
        end
      else
        spot.rule.build(rule_option_id: key, answer: value)
      end
    end
  end

  def invalid?
    spot.invalid? || spot.rule.map(&:invalid?).include?(true)
  end

  def add_spot_errors_spot
    delete_errors_not_to_display
    spot.errors.each do |error|
      errors.add(:base, error.full_message)
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

  def default_attributes
    {
      spot: spot,
      rules: rules,
    }
  end

  def delete_errors_not_to_display
    if spot.errors[:address]
      spot.errors.delete(:latitude)
      spot.errors.delete(:longitude)
    end
  end
end
