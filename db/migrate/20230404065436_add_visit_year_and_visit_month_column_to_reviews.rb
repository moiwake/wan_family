class AddVisitYearAndVisitMonthColumnToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :visit_date, :date, null: false
  end
end
