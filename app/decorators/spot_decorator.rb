class SpotDecorator < Draper::Decorator
  delegate_all

  def find_attached_rules
    rule.where(answer: "1").includes(:rule_option)
  end

  def get_checked_rule_opt
    rule.select { |r| r.answer == "1" }
  end
end
