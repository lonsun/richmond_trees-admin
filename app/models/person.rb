class Person < ActiveRecord::Base
  belongs_to :adoption_request

  def full_name
  	"#{self.first_name} #{self.last_name}".strip
  end
end
