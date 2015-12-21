class Zone < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"
  has_many :adoption_requests
end
