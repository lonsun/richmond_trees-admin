class Tree < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"
  has_many :adoption_requests
  has_many :plantings

  validates :common_name, :user_id, presence: true

  # Use to display the text in select options when choosing a tree
  def text_for_html_select_option
    self.common_name ||= ""
  end
end
