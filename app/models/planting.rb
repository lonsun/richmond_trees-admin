class Planting < ActiveRecord::Base
  belongs_to :parent_adoption_request, :class_name => "AdoptionRequest", :foreign_key => "adoption_request_id"
  belongs_to :tree_species, :class_name => "Tree", :foreign_key => "tree_id"
  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"
  has_many :maintenance_records, dependent: :destroy
  has_many :notes, dependent: :destroy

  validates :adoption_request_id, :tree_id, :user_id, :planted_on, presence: true

  # get the most recent maintenance record or nil if there are none
  def most_recent_maintenance_record
  	nil if self.id.nil? 

    mr = MaintenanceRecord.where( planting_id: self.id ).order( :maintenance_date ).reverse_order.limit( 1 )
    mr[ 0 ]
  end

  # use this to update the maintenance field on update
  def set_most_recent_maintenance_fields
    mr = self.most_recent_maintenance_record

    if mr.nil?
      self.last_maintenance_date = nil
      self.last_status_code = nil
    else
      self.last_maintenance_date = mr.maintenance_date
      self.last_status_code = mr.status_code
    end
  end
end
