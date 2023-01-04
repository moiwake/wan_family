module ApplicationHelper
  def who_signed_in?
    if current_user.present?
      return "user"
    elsif current_admin.present?
      return "admin"
    else
      return "others"
    end
  end

  def ary_present_and_include_ele?(ary: nil, ele: nil)
    if ary.present?
      ary.include?(ele)
    else
      false
    end
  end

  def get_prefecture_name(region)
    Prefecture.find_prefecture_name(region)
  end

  def liked?(review)
    current_user.like_reviews.exists?(review_id: review.id) if current_user.present?
  end
end
