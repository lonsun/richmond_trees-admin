class AddDefaultValueForIgnoreFields < ActiveRecord::Migration
  def change
    change_column :plantings, :ignore, :boolean, :default => false
    change_column :maintenance_records, :ignore, :boolean, :default => false
    change_column :notes, :ignore, :boolean, :default => false
    change_column :adoption_requests, :ignore, :boolean, :default => false
  end
end
