class Tree < ActiveRecord::Base
  validates :common_name, presence: true

end
