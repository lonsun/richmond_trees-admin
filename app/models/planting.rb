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

    mr = MaintenanceRecord.where( planting_id: self.id )
    mr = mr.where.not( ignore: true )
    mr = mr.order( :maintenance_date ).reverse_order.limit( 1 )
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

  def house_number
    self.parent_adoption_request.attributes.values_at( "house_number" )[0]
  end

  def street_name
    self.parent_adoption_request.attributes.values_at( "street_name" )[0]
  end

  def latitude
    self.parent_adoption_request.attributes.values_at( "latitude" )[0]
  end

  def longitude
    self.parent_adoption_request.attributes.values_at( "longitude" )[0]
  end

  def tree_common_name
    self.tree_species.attributes.values_at( "common_name" )[0]
  end

  def last_note
    if self.notes.last.nil?
      ""
    else
      self.notes.last.note
    end
  end

  def self.to_csv
    attributes = %w[ id planted_on house_number street_name latitude longitude placement tree_common_name last_maintenance_date last_status_code last_note ]

    CSV.generate( headers: true ) do |csv|
      csv << attributes

      all.each do |planting|
        csv << attributes.map{ |attr| planting.send( attr ) }
      end
    end
  end
end
