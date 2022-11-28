class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  has_many :images, dependent: :destroy

  validates :comment, presence: true
end
