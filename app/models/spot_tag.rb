class SpotTag < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :name, presence: true

  MAX_SPOT_TAG_DISPLAY_NUMBER = 3
  MAX_CREATED_NAME_DISPLAY_NUMBER = 10

  scope :created_spot_tag_names, -> (user_id:) {
    where(user_id: user_id)
    .order(updated_at: :desc, created_at: :desc)
    .limit(SpotTag::MAX_CREATED_NAME_DISPLAY_NUMBER)
    .pluck(:name)
  }

  scope :for_spot, -> (user_id:, spot_id:) {
    where(user_id: user_id, spot_id: spot_id)
    .order(updated_at: :desc, created_at: :desc)
  }
end
