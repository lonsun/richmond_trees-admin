class DropObsoleteTables < ActiveRecord::Migration
  def change
  	drop_table :addresses
  	drop_table :people
  end
end
