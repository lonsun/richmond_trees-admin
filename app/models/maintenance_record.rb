class MaintenanceRecord < ActiveRecord::Base
  belongs_to :planting

  before_save :reason_codes_to_s!

  validates :maintenance_date, :status_code, :diameter_breast_height, :presence => true

  # Tree status indicator.  A-F with A being the best (think school grades).
  STATUS_CODES = { :A => "VERY HEALTHY",
    :B => "GOOD",
    :C => "STRUGGLING",
    :D => "ALMOST DEAD",
    :F => "DEAD OR GONE" }

  # Reasons for a given status (mainly applicable to negative statuses).
  REASON_CODES = { :a => "needs water", 
    :b => "snapped leader", 
    :c => "binding ties",
    :d => "chaffing stakes", 
    :e => "nursery staked", 
    :f => "weak trunk", 
    :g => "damaged trunk",
    :h => "planted too deeply",
    :i => "planted too high",
    :j => "weeds/woody plants in basin",
    :k => "blight/disease/insects",
    :l => "wind damage",
    :m => "poor drainage",
    :n => "poor rooting",
    :o => "tree shaded by bldg, tree, etc.",
    :p => "poor structure",
    :q => "root crown buried after planting",
    :r => "leaf chlorosis" }

    # convert reason codes to string if it is an array.  Do nothing otherwise.
    def reason_codes_to_s!
      if self.reason_codes.is_a? Array
        t = self.reason_codes.reject { |r| r.strip.empty? }
        self.reason_codes = t.join(',')
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
end
