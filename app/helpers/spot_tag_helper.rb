module SpotTagHelper
  def tagged?(spot:)
    current_user.spot_tags.exists?(spot_id: spot.id)
  end

  def exceed_max?(spot_tags:)
    spot_tags.size > SpotTag::MAX_DISPLAY_NUMBER
  end

  def difference_of_max(spot_tags:)
    (spot_tags.size) - SpotTag::MAX_DISPLAY_NUMBER
  end
end
