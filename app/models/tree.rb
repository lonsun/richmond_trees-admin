class Tree < ActiveRecord::Base
  has_many :adoption_requests
  has_many :plantings

  validates :common_name, presence: true

  # Use to display the text in select options when choosing a tree
  def text_for_html_select_option
    self.common_name ||= ""
  end
end
