class AddTitleColumnToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :title, :string, null: false
  end
end
