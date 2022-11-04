module SpotsHelper
  def rule_opt_is_checked?(spot: nil, checked_rule_opt_ids: nil, rule_opt_id: nil)
    if spot.present?
      if checked_rule_opt_ids.include?(rule_opt_id)
        true
      end
    else
      false
    end
  end
end
