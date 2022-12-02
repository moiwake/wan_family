class AddDogScoreColumnToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :dog_score, :integer, null: false
  end
end
