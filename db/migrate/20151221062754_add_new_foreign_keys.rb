class AddNewForeignKeys < ActiveRecord::Migration
  def change
    add_reference :adoption_requests, :zone, index: true, foreign_key: true
    add_reference :zones, :user, index: true, foreign_key: true
  end
end
