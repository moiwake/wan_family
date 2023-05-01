class ReviewHelpfulness < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user, uniqueness: { scope: :review }
  validates_with ReviewHelpfulnessUserIdValidator
end
