class Spot < ApplicationRecord
  has_many         :spot_histories, dependent: :destroy
  has_many         :users, through: :spot_histories
  has_one_attached :image

  with_options presence: true do
    validates :name
    validates :latitude, uniqueness: { scope: :longitude }
    validates :longitude
    validates :address, uniqueness: true
    validates :category
    validates :allowed_area
  end
end
