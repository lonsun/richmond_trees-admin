require 'test_helper'

class MaintenanceRecordTest < ActiveSupport::TestCase
  setup do
    @maintenance_record = maintenance_records(:one)
  end

  describe "clean_reason_codes method" do
    it "works with a nil value" do
      @maintenance_record.reason_codes = nil
      @maintenance_record.clean_reason_codes!
      @maintenance_record.reason_codes.must_equal nil
    end

    it "returns a string of array values separated by commas" do
      @maintenance_record.reason_codes = ["a", "b", "c"]
      @maintenance_record.clean_reason_codes!.must_equal "a,b,c"
    end

    it "omits empty array values" do
      @maintenance_record.reason_codes = ["a", "b", "", " "]
      @maintenance_record.clean_reason_codes!.must_equal "a,b"
    end
  end

  describe "reason_codes_as_array method" do
    it "returns an empty array if reason codes is not a string or nil" do
      @maintenance_record.reason_codes = nil
      @maintenance_record.reason_codes_as_array.must_equal []
    end

    it "returns an array of the string split by commas" do
      @maintenance_record.reason_codes = "a,b,1"
      @maintenance_record.reason_codes_as_array.must_equal ["a", "b", "1"]
    end
  end

  describe "update_most_recent_fields_in_planting method" do
    it "updates the most recent maintenance date and status code in the associated planting" do
      @maintenance_record.update_most_recent_fields_in_planting      
      m2 = maintenance_records( :two )
      @maintenance_record.planting.last_maintenance_date.must_equal m2.maintenance_date
    end
  end
end
