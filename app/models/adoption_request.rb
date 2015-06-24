class AdoptionRequest < ActiveRecord::Base
  has_one :person
  has_one :address
  has_many :plantings

  accepts_nested_attributes_for :person, :address
end
