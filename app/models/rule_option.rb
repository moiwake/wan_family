class RuleOption < ApplicationRecord
  has_one :rule
  belongs_to :option_title

  validates :name, presence: true, uniqueness: true
end
