class AdoptionRequest < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"
  belongs_to :tree_species, :class_name => "Tree", :foreign_key => "tree_id"
  has_many :plantings, dependent: :destroy

  validates :house_number, :street_name, :user_id, :presence => true

  # Use to display the text in select options when choosing an adoption request
  def text_for_html_select_option
    html = self.owner_full_name
    html += ' | '
    html += self.full_address
    html
  end

  # Get full address
  def full_address
    "#{self.house_number.to_s} #{self.street_name}, #{self.city}, #{self.state}  #{self.zip_code}".strip
  end

  # Get full name of owner
  def owner_full_name
    "#{self.owner_first_name} #{self.owner_last_name}".strip
  end
end
