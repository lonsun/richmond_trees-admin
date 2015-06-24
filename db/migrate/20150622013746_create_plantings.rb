class CreatePlantings < ActiveRecord::Migration
  def change
    create_table :plantings do |t|
      t.belongs_to :adoption_request, index: true
      t.belongs_to :tree, index: true

      t.timestamps
    end
  end
end
