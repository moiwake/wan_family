class SpotTag < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :name, presence: true

  MAX_DISPLAY_NUMBER = 3
  MAX_CREATED_NAME_DISPLAY_NUMBER = 10

  scope :get_tag_names_user_created, -> (user_id:) {
    where(user_id: user_id).
      order(updated_at: :desc, created_at: :desc).
      pluck(:name).
      uniq
  }

  scope :get_tags_user_put_on_spot, -> (user_id:, spot_id:) {
    where(user_id: user_id, spot_id: spot_id).
      order(updated_at: :desc, created_at: :desc)
  }
end
