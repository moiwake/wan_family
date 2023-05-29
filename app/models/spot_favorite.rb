class SpotFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :spot, counter_cache: :spot_favorites_count

  validates :user, uniqueness: { scope: :spot }
end
