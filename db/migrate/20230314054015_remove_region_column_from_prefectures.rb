class RemoveRegionColumnFromPrefectures < ActiveRecord::Migration[6.1]
  def change
    remove_column :prefectures, :region
    remove_column :prefectures, :region_roma
  end
end
