class RemoveZoneFromAdoptionRequests < ActiveRecord::Migration
  def change
    remove_column :adoption_requests, :zone
  end
end
