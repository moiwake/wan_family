class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_one    :image, dependent: :destroy, autosave: true
  has_many   :review_helpfulnesses, dependent: :destroy

  with_options presence: true do
    validates :title
    validates :comment
    validates :dog_score
    validates :human_score
  end

  scope :load_all_associations, -> { eager_load(:user, :spot, image: :files_attachments).distinct.preload(:review_helpfulnesses) }
  scope :load_active_storage_associations, -> { preload(image: { files_attachments: { blob: :variant_records } }) }
end
