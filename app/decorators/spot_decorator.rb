class SpotDecorator < Draper::Decorator
  delegate_all

  def get_attached_saved_rules
    object.rules.where(answer: "1").eager_load(:rule_option)
  end

  def get_attached_unsaved_rules
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

  def get_spot_history_creation_date
    object.spot_histories.last.created_at
  end
end
