require 'test_helper'

class PlantingTest < ActiveSupport::TestCase
  setup do
    @planting = plantings(:one)
  end

  describe "most_recent_maintenance_record method" do
    it "returns the most recent maintenance record for a planting" do
      mr = maintenance_records( :two )
      @planting.most_recent_maintenance_record.maintenance_date.must_equal mr.maintenance_date
    end

    it "returns nil if the planting id is nil" do
      @planting.id = nil
      @planting.most_recent_maintenance_record.must_equal nil
    end

    it "returns nil if there is no associated maintenance record" do
      p2 = plantings( :two )
      p2.most_recent_maintenance_record.must_equal nil
    end
  end

  describe "set_most_recent_maintenance_fields method" do
    it "sets the state info from the most recent maintenance record" do
      m = maintenance_records( :two )
      @planting.set_most_recent_maintenance_fields
      @planting.last_maintenance_date.must_equal m.maintenance_date
      @planting.last_status_code.must_equal m.status_code
    end

    it "sets the state fields to nil if is no maintenance record" do
      p2 = plantings( :two )
      p2.set_most_recent_maintenance_fields
      @planting.last_maintenance_date.must_equal nil
      @planting.last_status_code.must_equal nil
    end
  end
end
