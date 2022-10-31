class AllowedArea < ApplicationRecord
  has_many :spots, dependent: :destroy

  validates :area, presence: true
end
