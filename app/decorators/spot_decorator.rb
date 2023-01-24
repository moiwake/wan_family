class SpotDecorator < Draper::Decorator
  delegate_all

  def find_attached_rules
    rules.where(answer: "1").eager_load(:rule_option)
  end

  def get_checked_rule_opt
    rules.select { |r| r.answer == "1" }
  end
end
