class Rule < ApplicationRecord
  belongs_to :spot
  belongs_to :rule_option

  with_options presence: true do
    validates :answer
  end

  validates :spot, uniqueness: { scope: :rule_option }
end
