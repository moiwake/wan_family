class SpotRegisterForm < FormBase
  attr_accessor :spot, :rules

  delegate :spot_histories, to: :spot

  def initialize(attributes: nil, spot: Spot.new, rules: nil)
    @spot = spot
    @rules = rules
    super(attributes: attributes)
  end

  def spot_attributes= (attributes)
    spot.assign_attributes(attributes)
  end

  def rule_attributes= (attributes)
    @recent_rules = []
    attributes["answer"].each do |key, value|
      @recent_rules << spot.rule.build(rule_option_id: key, answer: value)
    end
  end

  private

  def persist
    raise ActiveRecord::RecordInvalid unless spot.valid? || @recent_rules.each { |r| r.valid? }

    ActiveRecord::Base.transaction do
      spot.save

      set_rule_option_to_create
      set_rule_option_to_delete

      if @recent_rules.present?
        @recent_rules.each do |r|
          r.save if @added_rule_opt.include?(r.rule_option_id)
        end
      end

      if rules.present?
        removed_rules = rules.where(rule_option_id: [@removed_rule_opt])
        removed_rules.each(&:destroy)
      end
    end

    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    add_spot_errors_spot
    false
  end

  def default_attributes
    {
      spot: spot,
      rules: rules,
    }
  end

  def old_rule_option_ids
    rules.present? ? rules.pluck(:rule_option_id) : []
  end

  def recent_rule_option_ids
    @recent_rules.present? ? @recent_rules.pluck(:rule_option_id) : []
  end

  def set_rule_option_to_create
    @added_rule_opt = recent_rule_option_ids.difference(old_rule_option_ids)
  end

  def set_rule_option_to_delete
    @removed_rule_opt = old_rule_option_ids.difference(recent_rule_option_ids)
  end

  def add_spot_errors_spot
    delete_errors_not_to_display
    spot.errors.each do |error|
      errors.add(:base, error.full_message)
    end
  end

  def delete_errors_not_to_display
    if spot.errors[:address]
      spot.errors.delete(:latitude)
      spot.errors.delete(:longitude)
    end
  end
end

