class AddCompletedToAdoptionRequests < ActiveRecord::Migration
  def change
    add_column :adoption_requests, :completed, :boolean
  end
end
