class RenameScoreColumnOnReviews < ActiveRecord::Migration[6.1]
  def change
    rename_column :reviews, :score, :human_score
  end
end
