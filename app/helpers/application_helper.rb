module ApplicationHelper
  def paginated?(records)
    paginate records if records.methods.include?(:current_page)
  end

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

  def set_image_id(image_blob:, image_id: nil)
    image_id ? image_id : image_blob.attachments[0].record.id
  end

  def set_spot_id(image_blob:, spot_id: nil)
    spot_id ? spot_id : image_blob.attachments[0].record.spot_id
  end
end
