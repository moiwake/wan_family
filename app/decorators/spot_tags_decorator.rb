class SpotTagsDecorator < Draper::CollectionDecorator
  def exceed_max?
    object.size > SpotTag::MAX_DISPLAY_NUMBER
  end

  def difference_of_max
    object.size - SpotTag::MAX_DISPLAY_NUMBER
  end
end
