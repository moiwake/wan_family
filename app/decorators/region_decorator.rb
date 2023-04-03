class RegionDecorator < Draper::Decorator
  delegate_all

  def spot_total
    region.prefectures.map(&:spots).flatten.size
  end
end
