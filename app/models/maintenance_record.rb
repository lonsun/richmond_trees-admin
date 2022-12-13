require "json"

class MaintenanceRecord < ActiveRecord::Base
  belongs_to :planting
  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"

  before_save :clean_reason_codes!

  after_commit :update_most_recent_fields_in_planting

  validates :maintenance_date, :status_code, :diameter_breast_height, :user_id, :presence => true

  # Tree status indicator.  A-F with A being the best (think school grades).
  STATUS_CODES = { :A => "VERY HEALTHY",
    :B => "GOOD",
    :C => "STRUGGLING",
    :D => "ALMOST DEAD",
    :F => "DEAD OR GONE",
    :U => "UNKNOWN" }

  # Reasons for a given status (mainly applicable to negative statuses).
  REASON_CODES = { :a => "needs water", 
    :b => "snapped leader", 
    :c => "suckering",
    :d => "low vigor - reason unknown",
    :e => "poorly planted",
    :f => "weak trunk", 
    :g => "damaged trunk",
    :h => "planted too deeply",
    :i => "planted too high",
    :j => "weeds/grass plants in basin",
    :k => "blight/disease/insects",
    :l => "wind damage",
    :m => "poor drainage",
    :n => "poor rooting",
    :p => "poor structure",
    :q => "root crown buried after planting",
    :r => "leaf chlorosis" }

    # reason codes always come in as a printed array (String) - eg "[\"a\", \"b\"]"
    def clean_reason_codes!
      unless self.reason_codes.nil?
        begin
          reason_codes_arr = JSON.parse(self.reason_codes)
          reason_codes_arr = reason_codes_arr.reject { |r| r.strip.empty? }
          self.reason_codes = reason_codes_arr.join(',')
        rescue JSON::ParserError => e
          # do nothing
        end
      end
    end

    # return reason codes string as an array or an empty array if there is a problem.
    def reason_codes_as_array
      if self.reason_codes.is_a? String
        self.reason_codes.split(',')
      else
        []
      end
    end

    # change and save maintenance record state fields in plantings
    def update_most_recent_fields_in_planting
      p = self.planting
      p.set_most_recent_maintenance_fields
      p.save
    end
end
