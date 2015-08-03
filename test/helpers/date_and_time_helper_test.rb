require 'test_helper'

class DateAndTimeHelperTest < ActionView::TestCase
  setup do
    @time_utc = Time.now.utc
  end

  describe "#format_time_in_time_zone" do
    it "defaults to PST and uses default formatting" do
      @time_pst = @time_utc.in_time_zone( 'Pacific Time (US & Canada)' ) 

      format_time_in_time_zone( @time_utc ).must_equal @time_pst.strftime( DateAndTimeHelper::DEFAULT_FORMAT )
    end

    it "allows you to override the timezone" do
      est = 'Eastern Time (US & Canada)'
      @time_est = @time_utc.in_time_zone( est ) 

      format_time_in_time_zone( @time_utc, est ).must_equal @time_est.strftime( DateAndTimeHelper::DEFAULT_FORMAT )
    end

    it "returns an empty string if the time parameter is nil" do
      format_time_in_time_zone( nil ).must_equal ""
    end

    it "raises ArgumentError if time parameter is not correct" do
      proc { format_time_in_time_zone( "bad time" ) }.must_raise ArgumentError
    end
  end
end