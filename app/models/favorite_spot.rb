class FavoriteSpot < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :user, presence: true
  validates :user, uniqueness: { scope: :spot }
end
