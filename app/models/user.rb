class User < ActiveRecord::Base
  has_many :adoption_requests
  has_many :plantings
  has_many :maintenance_records
  has_many :notes
  
  # add authlogic
  acts_as_authentic do |c|
    # perishable tokens expire after 2 hours
    c.perishable_token_valid_for( 7200 )
  end

  validates :first_name, :last_name, :username, :email, presence: true
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  def full_name
    "#{self.first_name} #{self.last_name}".strip
  end

  def send_password_reset_email
    reset_perishable_token!
    Notifier.password_reset( self ).deliver
  end
end
