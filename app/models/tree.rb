class Tree < ActiveRecord::Base
  has_many :adoption_requests
  has_many :plantings

  validates :common_name, presence: true

end
