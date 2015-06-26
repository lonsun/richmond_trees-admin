class AdoptionRequest < ActiveRecord::Base
  has_one :person, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :plantings

  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :address

  def select_text
  	self.person.full_name
  end
end
