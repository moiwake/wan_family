class AllowedArea < ApplicationRecord
  has_many :spots

  validates :area, presence: true, uniqueness: true

  scope :order_default, -> { order(:id) }
end
