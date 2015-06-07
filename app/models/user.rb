class User < ActiveRecord::Base
  # add authlogic
  acts_as_authentic

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  def get_full_name
    "#{self.first_name} #{self.last_name}".strip
  end
end
