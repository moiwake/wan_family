class RuleOption < ApplicationRecord
  has_many :rule
  belongs_to :option_title

  with_options presence: true do
    validates :name, uniqueness: true
    validates :option_title
  end
end
