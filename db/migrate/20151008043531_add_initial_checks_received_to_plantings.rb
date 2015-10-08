class AddInitialChecksReceivedToPlantings < ActiveRecord::Migration
  def change
    add_column :plantings, :initial_checks_received, :boolean, default: false
  end
end
