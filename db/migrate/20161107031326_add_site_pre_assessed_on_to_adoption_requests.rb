class AddSitePreAssessedOnToAdoptionRequests < ActiveRecord::Migration
  def change
    add_column :adoption_requests, :site_pre_assessed_on, :date
  end
end
