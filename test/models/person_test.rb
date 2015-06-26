require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
    @person = people(:one)
  end

  describe "full_name method" do
    it "gets the full name of person" do
      @person.full_name.must_equal "Bob Jones"
    end

    it "omits leading space if first_name is not present" do
      @person.first_name = ""
      @person.full_name.must_equal "Jones"
    end

    it "omits trailing space if last_name is not present" do
      @person.last_name = ""
      @person.full_name.must_equal "Bob"
    end

    it "returns empty string if both are empty or nil" do
      @person.first_name = nil
      @person.last_name = ""
      @person.full_name.must_equal ""
    end
  end
end
