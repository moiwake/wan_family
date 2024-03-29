class Prefecture < ApplicationRecord
  has_many :spots

  belongs_to :region

  validates :name, presence: true, uniqueness: true
  validates :name_roma, presence: true, uniqueness: true
end
