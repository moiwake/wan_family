class ReviewHelpfulnessUserIdValidator < ActiveModel::Validator
  def validate(record)
    if record.user_id == Review.find(record.review_id).user_id
      record.errors.add :user, "投稿者が自分のレビューに「役立った」を登録することはできません。"
    end
  end
end
