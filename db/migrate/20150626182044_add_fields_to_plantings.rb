class AddFieldsToPlantings < ActiveRecord::Migration
  def change
  	add_column :plantings, :planted_on, :date, after: :tree_id
  	add_column :plantings, :event, :string
  	add_column :plantings, :placement, :string
  	add_column :plantings, :plant_space_width, :string
  	add_column :plantings, :stakes_removed, :boolean
  end
end
