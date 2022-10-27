class SpotHistory < ApplicationRecord
  belongs_to :spot
  belongs_to :user

  with_options presence: true do
    validates :spot
    validates :user
    validates :history
  end
end
