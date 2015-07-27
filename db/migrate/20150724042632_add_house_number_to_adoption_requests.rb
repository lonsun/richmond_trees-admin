class AddHouseNumberToAdoptionRequests < ActiveRecord::Migration
  def change
    add_column :adoption_requests, :house_number, :integer
  end
end
