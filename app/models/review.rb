class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_one    :image, dependent: :destroy, autosave: true
  has_many   :like_reviews, dependent: :destroy

  with_options presence: true do
    validates :title
    validates :comment
    validates :dog_score
    validates :human_score
  end

  scope :load_variant_image, -> { eager_load(:image).preload(image: { files_attachments: { blob: :variant_records } }) }
end
