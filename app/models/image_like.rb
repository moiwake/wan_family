class ImageLike < ApplicationRecord
  belongs_to :user
  belongs_to :image

  validates :blob_id, presence: true
  validates :user, uniqueness: { scope: :blob_id }
end
