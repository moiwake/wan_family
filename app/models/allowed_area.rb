class AllowedArea < ApplicationRecord
  belongs_to :category
  belongs_to :spot
end
