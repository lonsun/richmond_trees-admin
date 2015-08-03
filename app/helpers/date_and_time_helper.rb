module DateAndTimeHelper
  DEFAULT_FORMAT = "%Y-%m-%d %H:%M:%S"

  def format_time_in_time_zone( time, timezone = 'Pacific Time (US & Canada)' )
    return "" if time.nil?
    raise ArgumentError.new( '1st parameter must be a Time object.' ) unless time.kind_of? Time
    
    time.in_time_zone( timezone ).strftime( DEFAULT_FORMAT  )
  end
end