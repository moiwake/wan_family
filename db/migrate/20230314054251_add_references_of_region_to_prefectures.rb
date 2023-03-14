class AddReferencesOfRegionToPrefectures < ActiveRecord::Migration[6.1]
  def change
    add_reference :prefectures, :region, null: false, foreign_key: true
  end
end
