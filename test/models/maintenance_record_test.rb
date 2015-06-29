require 'test_helper'

class MaintenanceRecordTest < ActiveSupport::TestCase
  setup do
    @maintenance_record = maintenance_records(:one)
  end

  describe "reason_codes_to_s method" do
    it "reason_codes is not altered if it is not an array" do
      @maintenance_record.reason_codes = "a"
      @maintenance_record.reason_codes_to_s!
      @maintenance_record.reason_codes.must_equal "a"
    end

    it "returns a string of array values separated by commas" do
      @maintenance_record.reason_codes = ["a", "b", "c"]
      @maintenance_record.reason_codes_to_s!.must_equal "a,b,c"
    end

    it "omits empty array values" do
      @maintenance_record.reason_codes = ["a", "b", "", " "]
      @maintenance_record.reason_codes_to_s!.must_equal "a,b"
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
end
