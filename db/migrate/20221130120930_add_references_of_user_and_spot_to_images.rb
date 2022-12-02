class AddReferencesOfUserAndSpotToImages < ActiveRecord::Migration[6.1]
  def change
    add_reference :images, :user, null: false, foreign_key: true
    add_reference :images, :spot, null: false, foreign_key: true
  end
end
