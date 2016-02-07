class AddIgnoreToManyModels < ActiveRecord::Migration
  def change
    add_column :plantings, :ignore, :boolean
    add_column :maintenance_records, :ignore, :boolean
    add_column :notes, :ignore, :boolean
    add_column :adoption_requests, :ignore, :boolean
  end
end
