class SpotHistory < ApplicationRecord
  belongs_to :spot
  belongs_to :user

  validates :history, presence: true
end
