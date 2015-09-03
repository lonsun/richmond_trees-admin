class AddLatitudeAndLongitudeToAdoptionRequests < ActiveRecord::Migration
  def change
    add_column :adoption_requests, :latitude, :decimal, {:precision=>10, :scale=>6}
    add_column :adoption_requests, :longitude, :decimal, {:precision=>10, :scale=>6}
  end
end
