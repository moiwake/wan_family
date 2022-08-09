class ChangeColumnAddNotNullOnUserName < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :user_name, false
  end
end
