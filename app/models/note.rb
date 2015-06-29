class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :planting

  validates :planting_id, :user_id, :note, :presence => true

  def created_by_name
  	user = User.find_by id: self.user_id
  	user.full_name
  end
end
