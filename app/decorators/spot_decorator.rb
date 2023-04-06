class SpotDecorator < Draper::Decorator
  delegate_all

  def find_attached_rules
    object.rules.where(answer: "1").eager_load(:rule_option)
  end

  def get_checked_rule_opt
    object.rules.select { |r| r.answer == "1" }
  end

  def get_dog_score_avg
    if object.reviews.any?
      object.reviews.average(:dog_score).round(1)
    end
  end

  def get_human_score_avg
    if object.reviews.any?
      object.reviews.average(:human_score).round(1)
    end
  end
end
