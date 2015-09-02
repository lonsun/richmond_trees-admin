class SetDefaultValueForZone < ActiveRecord::Migration
  def change
    change_column :adoption_requests, :zone, :string, :null => false, :default => ""
  end
end
