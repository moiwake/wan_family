class RegionDecorator < Draper::Decorator
  delegate_all

  def spot_total
    object.prefectures.map(&:spots).flatten.size
  end
end
