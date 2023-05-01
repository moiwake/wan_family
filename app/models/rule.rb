class Rule < ApplicationRecord
  belongs_to :spot
  belongs_to :rule_option

  validates :answer, presence: true
  validates :spot, uniqueness: { scope: :rule_option }
end
