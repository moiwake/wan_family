class Rule < ApplicationRecord
  belongs_to :spot
  belongs_to :rule_option

  with_options presence: true do
    validates :spot
    validates :rule_option
    validates :answer
  end
end
