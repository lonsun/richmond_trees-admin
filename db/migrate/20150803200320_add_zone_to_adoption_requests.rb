class AddZoneToAdoptionRequests < ActiveRecord::Migration
  def change
    add_column :adoption_requests, :zone, :string
  end
end
