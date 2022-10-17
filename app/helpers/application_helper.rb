module ApplicationHelper
  def who_signed_in?
    if current_user.present?
      return "user"
    elsif current_admin.present?
      return "admin"
    end
    return nil
  end
end
