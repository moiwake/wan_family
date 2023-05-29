class AddImpressionsCountToSpots < ActiveRecord::Migration[6.1]
  def change
    add_column :spots, :impressions_count, :integer, default: 0
  end
end
