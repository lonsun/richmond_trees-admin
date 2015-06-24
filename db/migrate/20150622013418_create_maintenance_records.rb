class CreateMaintenanceRecords < ActiveRecord::Migration
  def change
    create_table :maintenance_records do |t|
      t.string :status_code
      t.string :reason_code
      t.string :diameter_breast_height
      t.belongs_to :planting, index: true

      t.timestamps
    end
  end
end
