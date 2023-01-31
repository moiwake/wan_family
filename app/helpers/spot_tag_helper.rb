module SpotTagHelper
  def tagged?(spot:)
    current_user.spot_tags.exists?(spot_id: spot.id)
  end
end
