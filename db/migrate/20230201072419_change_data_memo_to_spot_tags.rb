class ChangeDataMemoToSpotTags < ActiveRecord::Migration[6.1]
  def change
    change_column :spot_tags, :memo, :text
  end
end
