class SpotTag < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :name, presence: true

  MAX_SPOT_TAG_DISPLAY_NUMBER = 3
end
