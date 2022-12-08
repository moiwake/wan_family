class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_one    :image, dependent: :destroy

  with_options presence: true do
    validates :title
    validates :comment
    validates :dog_score
    validates :human_score
  end
end