class AddUniqueIndexToRuleOptionIdAndSpotIdInRules < ActiveRecord::Migration[6.1]
  def change
    add_index :rules, [:rule_option_id, :spot_id], unique: true
  end
end
