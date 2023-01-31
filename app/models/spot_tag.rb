class SpotTag < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :name, presence: true
end
