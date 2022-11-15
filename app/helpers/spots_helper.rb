module SpotsHelper
  def rule_opt_is_attached?(attached_rule_opt_ids: nil, rule_opt_id: nil)
    if attached_rule_opt_ids.present?
      if attached_rule_opt_ids.include?(rule_opt_id)
        true
      end
    else
      false
    end
  end
end
