class Planting < ActiveRecord::Base
  belongs_to :parent_adoption_request, :class_name => "AdoptionRequest", :foreign_key => "adoption_request_id"
  belongs_to :tree_species, :class_name => "Tree", :foreign_key => "tree_id"
  has_many :maintenance_records
  has_many :notes

  validates :adoption_request_id, :tree_id, presence: true

end
