class Image < ApplicationRecord
  belongs_to :spot
  belongs_to :user

  has_one_attached :file

  with_options presence: true do
    validates :file
  end
end
