class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
