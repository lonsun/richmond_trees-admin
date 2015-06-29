class ChangeMaintenanceRecordColumnNAme < ActiveRecord::Migration
  def change
  	rename_column :maintenance_records, :reason_code, :reason_codes
  end
end
