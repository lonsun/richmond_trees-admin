class AddStateFieldsToPlanting < ActiveRecord::Migration
  def change
    add_column :plantings, :last_maintenance_date, :date
    add_column :plantings, :last_status_code, :string
  end
end
