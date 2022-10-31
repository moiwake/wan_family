class OptionTitle < ApplicationRecord
  has_many :rule_option, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
