class SpotDecorator < Draper::Decorator
  delegate_all

  def find_checked_rules
    rule.where(answer: "1").includes(:rule_option)
  end
end
