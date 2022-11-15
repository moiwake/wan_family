class AllowedArea < ApplicationRecord
  has_many :spots, dependent: :destroy

  validates :area, presence: true, uniqueness: true
end
