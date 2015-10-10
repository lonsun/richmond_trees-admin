require 'test_helper'

class PlantingTest < ActiveSupport::TestCase
  setup do
    @planting = plantings( :one )
    @adoption_request = adoption_requests( :one )
    @tree = trees( :one )
    @note = notes( :one )
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

  describe "#house_number" do
    it "gets the associated house number" do
      @planting.house_number.must_equal @adoption_request.house_number
    end
  end

  describe "#street_name" do
    it "gets the associated street name" do
      @planting.street_name.must_equal @adoption_request.street_name
    end
  end

  describe "#tree_common_name" do
    it "gets the common name for the associated tree" do
      @planting.tree_common_name.must_equal @tree.common_name
    end
  end

  describe "#last_note" do
    it "gets the last note if it exists" do
      @planting.last_note.must_equal @note.note
    end

    it "returns an empty string if there is no last note" do
      @p2 = plantings( :two )
      @p2.last_note.must_be_empty
    end
  end

  describe ".to_csv" do
    it "returns the relation in csv format" do
      @plantings = Planting.all
      
      # simple test - just count the number of lines
      output = @plantings.to_csv
      output.count("\n").must_equal @plantings.count+1
    end
  end
end
