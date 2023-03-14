class Region < ApplicationRecord
  has_many :prefectures

  validates :name, presence: true, uniqueness: true
  validates :name_roma, presence: true, uniqueness: true
end
