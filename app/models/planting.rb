class Planting < ActiveRecord::Base
  has_many :maintenance_records
  has_many :notes
end
