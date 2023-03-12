class Category < ApplicationRecord
  has_many :spots

  validates :name, presence: true, uniqueness: true

  scope :order_default, -> { order(:id) }
end
