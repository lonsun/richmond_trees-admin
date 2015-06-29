class AddMaintenanceDateToMaintenanceRecord < ActiveRecord::Migration
  def change
    add_column :maintenance_records, :maintenance_date, :date
  end
end
