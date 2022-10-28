class SpotHistory < ApplicationRecord
  belongs_to :spot
  belongs_to :user

  with_options presence: true do
    validates :history
  end
end
