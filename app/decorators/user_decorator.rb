class UserDecorator < Draper::Decorator
  delegate_all

  def display_human_avatar
    if object.human_avatar.attached?
      object.human_avatar.representation(resize_to_limit: [180, 180], gravity: "center", crop: "130x130+0+0")
    else
      "noavatar-human.png"
    end
  end

  def display_dog_avatar
    if object.dog_avatar.attached?
      object.dog_avatar.representation(resize_to_limit: [180, 180], gravity: "center", crop: "130x130+0+0")
    else
      "noavatar-dog.png"
    end
  end
end
