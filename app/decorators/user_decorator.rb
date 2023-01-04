class UserDecorator < Draper::Decorator
  delegate_all

  def display_human_avatar
    if object.human_avatar.attached?
      object.human_avatar
    else
      "noavatar-human.png"
    end
  end

  def display_dog_avatar
    if object.dog_avatar.attached?
      object.dog_avatar
    else
      "noavatar-dog.png"
    end
  end
end
