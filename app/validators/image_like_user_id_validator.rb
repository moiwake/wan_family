class ImageLikeUserIdValidator < ActiveModel::Validator
  def validate(record)
    if record.user_id == Image.find(record.image_id).user_id
      record.errors.add :user, "投稿者が自分の画像に「いいね」を登録することはできません。"
    end
  end
end
