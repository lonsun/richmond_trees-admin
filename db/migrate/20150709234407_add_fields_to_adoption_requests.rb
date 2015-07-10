class AddFieldsToAdoptionRequests < ActiveRecord::Migration
  def change
    add_column :adoption_requests, :spanish_speaker, :boolean
    add_column :adoption_requests, :room_for_tree, :boolean
    add_column :adoption_requests, :concrete_removal, :boolean
    add_column :adoption_requests, :wires, :boolean
    add_column :adoption_requests, :source, :string
    add_column :adoption_requests, :received_on, :date
    add_column :adoption_requests, :contacted_on, :date
    add_column :adoption_requests, :form_sent_to_cor_on, :date
    add_column :adoption_requests, :site_assessed_on, :date
    add_column :adoption_requests, :number_of_trees, :integer
    add_column :adoption_requests, :plant_space_width, :string
    add_column :adoption_requests, :note, :text
  end
end
