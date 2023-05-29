class ReviewHelpfulness < ApplicationRecord
  belongs_to :user
  belongs_to :review, counter_cache: :review_helpfulnesses_count

  validates :user, uniqueness: { scope: :review }
  validates_with ReviewHelpfulnessUserIdValidator
end
