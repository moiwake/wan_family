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

  def get_image_id(blob)
    blob.attachments[0].record.id
  end

  def get_spot_id(blob)
    blob.attachments[0].record.spot_id
  end
end
