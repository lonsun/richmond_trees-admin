class AddFailedLoginCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :failed_login_count, :integer
  end
end
