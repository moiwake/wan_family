class AllowedArea < ApplicationRecord
  has_many :spots

  validates :area, presence: true
end
