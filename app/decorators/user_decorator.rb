class UserDecorator < Draper::Decorator
  delegate_all

  def display_avatar
    if object.avatar.attached?
      object.avatar
    else
      "noavatar.png"
    end
  end
end
