class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.string :common_name
      t.string :scientific_name
      t.string :family_name

      t.timestamps
    end
  end
end
