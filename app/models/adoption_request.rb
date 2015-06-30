class AdoptionRequest < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"
  has_one :person, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :plantings, dependent: :destroy

  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :address

  validates :user_id, :presence => true

  # Use to display the text in select options when choosing an adoption request
  def text_for_html_select_option
    html = self.person.nil? ? "" : self.person.full_name
    html += ' | '
    html += self.address.full_address unless self.address.nil?
    html
  end
end
