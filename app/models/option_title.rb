class OptionTitle < ApplicationRecord
  has_many :rule_option

  validates :name, presence: true, uniqueness: true
end
