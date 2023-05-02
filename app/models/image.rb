class Image < ApplicationRecord
  has_many :image_likes, dependent: :destroy

  belongs_to :user
  belongs_to :spot
  belongs_to :review

  has_many_attached :files

  validates :files, presence: true, blob: {
    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
    size_range: 1..(5.megabytes),
  }

  PER_PAGE = 100
end
