class Image < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  belongs_to :review

  has_many_attached :files

  with_options presence: true do
    validates :files
  end
end
