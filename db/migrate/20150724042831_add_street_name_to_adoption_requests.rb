class AddStreetNameToAdoptionRequests < ActiveRecord::Migration
  def change
    add_column :adoption_requests, :street_name, :string
  end
end
