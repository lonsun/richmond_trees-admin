class RemoveStreetAddressColumnFromAdoptionRequests < ActiveRecord::Migration
  def change
  	remove_column :adoption_requests, :street_address
  end
end
