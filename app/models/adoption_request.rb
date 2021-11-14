class AdoptionRequest < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"
  belongs_to :tree_species, :class_name => "Tree", :foreign_key => "tree_id"
  belongs_to :zone
  has_many :plantings, dependent: :destroy

  validates :received_on, :house_number, :street_name, :user_id, :presence => true

  geocoded_by :full_address
  after_validation :geocode, if: lambda { |obj| !obj.full_address.nil? && obj.changed.any? { |a| a.index( /^(house_number|street_name|city|state|zip_code)$/ ) } }

  DEFAULT_CITY = "Richmond"
  DEFAULT_STATE = "CA"

  # Use to display the text in select options when choosing an adoption request
  def text_for_html_select_option
    html = self.full_address
    html += ' | '
    html += self.owner_full_name
    html.gsub( /\s\s/, ' ' )
  end

  # Get street address
  def street_address
    "#{ self.house_number } #{ self.street_name }"
  end

  # Get full address
  def full_address
    [ self.street_address, self.city, self.state, self.zip_code ].compact.join( ', ' )
  end

  # Get full name of owner
  def owner_full_name
    "#{self.owner_first_name} #{self.owner_last_name}".strip
  end

  def self.to_csv
    attributes = %w[ id received_on house_number street_name zip_code completed ]

    CSV.generate( headers: true ) do |csv|
      csv << self.attribute_names

      all.each do |ar|
        csv << ar.attributes.values
      end
    end
  end

end
