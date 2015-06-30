class Note < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"
  belongs_to :planting

  validates :planting_id, :user_id, :note, :presence => true
end
