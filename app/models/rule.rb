class Rule < ApplicationRecord
  belongs_to :spot
  belongs_to :rule_option
end
