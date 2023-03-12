class Prefecture < ApplicationRecord
  has_many :spots

  validates :name, presence: true, uniqueness: true
  validates :name_roma, presence: true, uniqueness: true
  validates :region, presence: true
  validates :region_roma, presence: true
end
