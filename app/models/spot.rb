class Spot < ApplicationRecord
  with_options presence: true do
    validates :name
    validates :latitude, uniqueness: { scope: :longitude }
    validates :longitude
    validates :address, uniqueness: true
    validates :category
    validates :allowed_area
  end
end
