class OptionTitle < ApplicationRecord
  has_many :rule_options, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :order_default, -> { order(:id) }
end
