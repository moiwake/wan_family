class RuleOption < ApplicationRecord
  has_many :rule
  belongs_to :option_title
end
