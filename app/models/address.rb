class Address < ActiveRecord::Base
  belongs_to :adoption_request

  validates :street_address, :presence => true
  
  def full_address
    "#{self.street_address}, #{self.city}, #{self.state}  #{self.zip_code}".strip
  end
end
