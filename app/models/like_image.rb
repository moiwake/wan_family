class LikeImage < ApplicationRecord
  belongs_to :user
  belongs_to :image

  validates :blob_id, presence: true
  validates :blob_id, uniqueness: { scope: :user_id }
end
