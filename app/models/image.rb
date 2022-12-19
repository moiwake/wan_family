class Image < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  belongs_to :review

  has_many_attached :files

  validates :files, presence: true, blob: {
    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
    size_range: 1..(5.megabytes)
  }

  MAX_IMAGE_DISPLAY_NUMBER = 5
  MAX_IMAGE_DISPLAY_NUMBER_PER_1_REVIEW = 1
end
