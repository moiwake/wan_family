class SpotRegisterForm < FormBase
  attr_accessor :spot

  def initialize(attributes: nil, spot: Spot.new)
    @spot = spot
    super(attributes: attributes)
  end

  def spot_attributes= (attributes)
    attributes = merge_prefecture_id(attributes)
    spot.assign_attributes(attributes)
  end

  def rules_attributes= (attributes)
    attributes.each do |key, value|
      if spot.new_record?
        build_rule_records(rule_option_id: key, answer: value["answer"])
      else
        update_rules_attributes(rule_option_id: key, answer: value["answer"])
      end
    end
  end

  private

  def persist
    raise ActiveRecord::RecordInvalid if check_and_add_error
    spot.save!
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end

  def build_rule_records(rule_option_id: nil, answer: nil)
    spot.rules.build(rule_option_id: rule_option_id, answer: answer)
  end

  def update_rules_attributes(rule_option_id: nil, answer: nil)
    spot.rules.each do |r|
      if r.rule_option_id.to_s == rule_option_id
        r.attributes = { answer: answer }
      end
    end
  end

  def check_and_add_error
    spot.invalid? ? add_spot_errors : false
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
      spot.errors.delete(:prefecture)
    end
  end

  def merge_prefecture_id(attributes)
    prefecture_id = Prefecture.find_by(name: attributes["address"].match(/.*[都道府県]/).to_s).id
    attributes.merge({ "prefecture_id" => prefecture_id })
  end

  def default_attributes
    {
      spot: spot,
    }
  end
end
