class Rule < ApplicationRecord
  belongs_to :spot
  belongs_to :rule_option

  with_options presence: true do
    validates :answer
    validates :spot
  end
end
