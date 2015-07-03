class AddFieldsToAdoptionRequest < ActiveRecord::Migration
  def change
  	add_column :adoption_requests, :owner_first_name, :string
  	add_column :adoption_requests, :owner_last_name, :string
  	add_column :adoption_requests, :owner_email, :string
  	add_column :adoption_requests, :owner_phone, :string
  	add_column :adoption_requests, :street_address, :string
  	add_column :adoption_requests, :city, :string
  	add_column :adoption_requests, :state, :string
  	add_column :adoption_requests, :zip_code, :string
  end
end
