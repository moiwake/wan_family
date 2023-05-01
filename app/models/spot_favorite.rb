class SpotFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :user, uniqueness: { scope: :spot }
end
